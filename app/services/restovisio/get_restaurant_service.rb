# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Restovisio
  class GetRestaurantService
    class << self
      def call(page)
        html_doc = fetch_html(page)
        find_or_create_restaurant(html_doc)
      end

      private

      def fetch_html(page)
        url = "http://www.restovisio.com/restaurants/#{page}.htm"
        sleep 3 unless Rails.env.test?
        html_file = URI.parse(url).open
        Nokogiri::HTML(html_file)
      end

      def find_or_create_restaurant(html_doc)
        html_doc.css('.item_infos').each do |restaurant|
          resto = get_all_data(restaurant)
          get_link(restaurant)
          retrieve_address(resto)
          sleep 2 unless Rails.env.test?

          Restovisio::GetRestaurantMenuWorker.perform_async(@link, resto.id)
        end
      end

      def get_all_data(restaurant)
        name = restaurant.css('a').first.text.strip
        tags = restaurant.css('.etb_cat_amb').text.strip.split(',')
        address = restaurant.css('.etb_location_info').text.strip
        Restaurant.where(name: name, slug: name.parameterize,
                         address: address, tags: tags,
                         source: 'restovisio').first_or_create
      end

      def retrieve_address(resto)
        FormatAddressesService.call(resto)
      end

      def get_link(restaurant)
        restaurant.css('a:first').each do |link|
          link = link['href']
          @link = "#{link.chomp('#bookings').chomp('#mobile')}#menu"
        end
      end
    end
  end
end
