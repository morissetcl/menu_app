# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Glovo
  class GetRestaurantGlovoService
    class << self
      def call(address)
        html_doc = fetch_html(address)
        create_restaurant(html_doc)
      end

      private

      def fetch_html(address)
        html_file = URI.parse(address).open
        Nokogiri::HTML(html_file)
      end

      def create_restaurant(html_doc)
        html_doc.css('.collection-item').each do |restaurant|
          name = restaurant.css('.title').text
          tags = restaurant.css('.description').text
          link = restaurant.first[1]
          restaurant = Restaurant.where(name: name, slug: name.parameterize,
                                        source: 'glovo').first_or_create
          restaurant.update(tags: tags)
          sleep 2 unless Rails.env.test?
          Glovo::GetRestaurantMenuWorker.perform_async(restaurant.id, link)
        end
      end
    end
  end
end
