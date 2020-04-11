# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Deliveroo
  class GetRestaurantWorker
    include Sidekiq::Worker

    def perform(*_args)
      DISTRICTS.each do |district|
        html_doc = fetch_html(district)
        Deliveroo::GetRestaurantService.call(html_doc)
      end
    end

    private

    def fetch_html(district)
      url = "https://deliveroo.fr/fr/restaurants/paris/#{district}"
      sleep 3 unless Rails.env.test?
      html_file = URI.parse(url).open
      Nokogiri::HTML(html_file)
    end
  end
end
