# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'menu_justeat'

    def perform(*_args)
      cities = JUSTEAT_CITIES + PARIS
      cities.each do |link|
        Justeat::GetRestaurantService.call(link)
        sleep 3 unless Rails.env.test?
      end
    end
  end
end
