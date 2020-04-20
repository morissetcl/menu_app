# frozen_string_literal: true

module Glovo
  class GetRestaurantMenuGlovoService
    class << self
      def call(restaurant_id, link)
        sleep 2 unless Rails.env.test?
        restaurant = Restaurant.find restaurant_id
        html_doc = fetch_html(link)
        create_dishes(html_doc, restaurant)
      end

      private

      def fetch_html(link)
        url = "https://glovoapp.com#{link}"
        html_file = URI.parse(url).open
        Nokogiri::HTML(html_file)
      end

      def create_dishes(html_doc, restaurant)
        html_doc.css('.collection-item').each do |element|
          title = element.css('.title').text.strip
          price = element.css('.price').text.strip.split[0].gsub(',', '.')
          Dish.where(title: title, restaurant_id: restaurant.id, price: price).first_or_create
        end
      end
    end
  end
end
