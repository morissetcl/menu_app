# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Foodin
  class GetRestaurantFoodinService
    class << self
      def call(city)
        html_doc = fetch_html(city)
        create_restaurant(html_doc)
      end

      private

      def fetch_html(city)
        url = "https://foodin.fr/nos-restaurants/#{city}"
        html_file = URI.parse(url).open
        Nokogiri::HTML(html_file)
      end

      def create_restaurant(html_doc)
        html_doc.css('.restaurant-container').each do |restaurant|
          name = restaurant.css('.name-restaurant-value').text.strip
          tags = restaurant.css('.speciality').text.split('-')
          get_link(restaurant)
          resto = Restaurant.where(name: name, slug: name.parameterize,
                                   tags: tags, source: 'foodin').first_or_create
          sleep 2 unless Rails.env.test?
          Foodin::GetRestaurantMenuWorker.perform_async(@link, resto.id)
        end
      end

      def get_link(restaurant)
        restaurant.css('a:first').each do |link|
          @link = link['href']
        end
      end
    end
  end
end
