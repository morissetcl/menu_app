# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Deliveroo
  class GetRestaurantService
    class << self
      def call(html_doc)
        create_restaurant(html_doc)
      end

      private

      def create_restaurant(html_doc)
        html_doc.search('.RestaurantsList-8608590270dc6ae3').each do |element|
          links = element.css('a')
          links.each do |restaurant|
            next if get_data(restaurant).blank?

            find_create_restaurant(restaurant)

            Deliveroo::GetRestaurantMenuWorker.perform_async(restaurant['href'],
                                                             get_data(restaurant))
          end
        end
      end

      def find_create_restaurant(restaurant)
        Restaurant.where(name: get_name(get_data(restaurant)),
                         slug: get_data(restaurant),
                         source: 'deliveroo').first_or_create
      end

      def get_data(restaurant)
        link_clean = get_link(restaurant['href'])
        get_slug(link_clean)
      end

      def get_link(link)
        return '' if link.nil?

        link.scan(%r{(?<=https://deliveroo.fr/menu/paris/)(.*)(?=\?day=today&time=ASAP)})
      end

      def get_slug(link)
        link.flatten.join.split('/').last
      end

      def get_name(slug)
        slug.tr('-', ' ').humanize
      end
    end
  end
end
