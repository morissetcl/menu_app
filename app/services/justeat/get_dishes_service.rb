# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetDishesService
    class << self
      def call(html_doc, restaurant)
        get_food_tags(html_doc, restaurant)
        create_dishes(html_doc, restaurant)
      end

      def create_dishes(html_doc, restaurant)
        html_doc.css('.product').each do |element|
          title = element.css('h4').text.strip
          price = element.css('.price').text.strip.split[0].gsub(',', '.')
          description = element.css('.description').text.strip
          Dish.where(title: title, restaurant_id: restaurant.id,
                     price: price, description: description).first_or_create
        end
      end

      def get_food_tags(html_doc, restaurant)
        tags = html_doc.css('.cuisines')
        food_type = []
        tags.css('li').each do |food|
          food_type << food.text
        end
        restaurant.update!(tags: food_type)
      end
    end
  end
end
