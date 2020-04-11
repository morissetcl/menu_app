# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Foodin
  class GetRestaurantWorker
    include Sidekiq::Worker

    def perform(*_args)
      FOODIN_CITIES.each do |city|
        Foodin::GetRestaurantFoodinService.call(city)
      end
    end
  end
end
