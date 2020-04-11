# frozen_string_literal: true

module Justeat
  class GetRestaurantMenuService
    class << self
      def call(link, restaurant_slug)
        sleep 2 unless Rails.env.test?
        restaurant = Restaurant.find_by(slug: restaurant_slug)
        html_doc = fetch_html(link)
        GetDishesService.call(html_doc, restaurant)
      end

      private

      def fetch_html(link)
        html_file = URI.parse(link).open
        Nokogiri::HTML(html_file)
      end
    end
  end
end
