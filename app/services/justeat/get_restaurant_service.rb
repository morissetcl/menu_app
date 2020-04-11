# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantService
    class << self
      def call(page)
        html_doc = initialize_crawl(page)
        html_doc.css('.restaurantDetails').each do |element|
          get_link_and_name(element)
          Restaurant.where(name: @name, slug: @name.parameterize,
                           address: @address, source: 'justeat').first_or_create
          Justeat::GetRestaurantMenuWorker.perform_async(@link, @name.parameterize)
        end
      end

      def initialize_crawl(page)
        link = "https://www.just-eat.fr/livraison/paris/paris/?page=#{page}"
        html_file = URI.parse(link).open
        Nokogiri::HTML(html_file)
      end

      def get_link_and_name(element)
        @name = element.css('h3').text
        links = element.css('a')
        links.each do |restaurant|
          @link = restaurant['href']
        end
        @address = element.css('address').text
      end
    end
  end
end
