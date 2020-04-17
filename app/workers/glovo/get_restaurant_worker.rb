# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Glovo
  class GetRestaurantWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'restaurants_glovo'

    def perform(*_args)
      GLOVO_CITIES.each do |city|
        Glovo::GetRestaurantGlovoService.call(city)
      end
    end
  end
end
