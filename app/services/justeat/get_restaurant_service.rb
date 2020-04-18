# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantService
    class << self
      def call(link)
        html_doc = initialize_crawl(link)
        html_doc.css('.restaurantDetails').each do |element|
          get_link_and_name(element)
          restaurant = Restaurant.where(name: @name, slug: @name.parameterize,
                                        address: @address, source: 'justeat').first_or_create
          FormatAddressesService.new(restaurant).call
          Justeat::GetRestaurantMenuWorker.perform_async(@link, restaurant.slug)
        end
      end

      private

      def initialize_crawl(link)
        sleep 2 unless Rails.env.test?

        html = URI.parse(link).open
        Nokogiri::HTML(html)
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
