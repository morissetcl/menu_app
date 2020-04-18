# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'menu_justeat'

    def perform(*_args)
      html_doc = retrieve_cities
      html_doc.css('.locations').each do |element|
        links = element.css('a')
        links.each do |restaurant|
          link = restaurant['href']
          sleep 2 unless Rails.env.test?

          Justeat::GetRestaurantService.call("https://#{link[2..-1]}")
        end
      end
    end

    def retrieve_cities
      link = 'https://www.just-eat.fr/livraison/villes/'
      html_file = URI.parse(link).open
      Nokogiri::HTML(html_file)
    end
  end
end
