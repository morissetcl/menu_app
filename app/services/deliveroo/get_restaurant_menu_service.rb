# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Deliveroo
  class GetRestaurantMenuService
    class << self
      def call(link, restaurant_slug)
        sleep 2 unless Rails.env.test?
        restaurant = Restaurant.find_by(slug: restaurant_slug)
        html_doc = fetch_html(link)
        assign_tags_to_restaurant(html_doc, restaurant)
        get_address_and_update_restaurant(html_doc, restaurant)
        create_dishes(html_doc, restaurant)
      end

      def assign_tags_to_restaurant(html_doc, restaurant)
        food_type = []
        html_doc.css('.food').each do |a|
          food_type << a.text
        end
        restaurant.update!(tags: food_type)
        FormatAddressesService.call(restaurant)
      end

      def fetch_html(link)
        html_file = URI.parse(link).open
        Nokogiri::HTML(html_file)
      end

      def get_address_and_update_restaurant(html_doc, restaurant)
        address = html_doc.css('.address').text
        restaurant.update(address: address)
      end

      def create_dishes(html_doc, restaurant)
        html_doc.css('.menu-index-page__item-content').each do |element|
          title = element.css('.menu-index-page__item-title').text
          price = element.css('.menu-index-page__item-price').text
          Dish.create(title: title, restaurant_id: restaurant.id, price: price)
        end
      end
    end
  end
end
