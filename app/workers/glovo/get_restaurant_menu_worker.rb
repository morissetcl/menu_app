# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Glovo
  class GetRestaurantMenuWorker
    include Sidekiq::Worker

    def perform(restaurant_id, link)
      Glovo::GetRestaurantMenuGlovoService.call(restaurant_id, link)
    end
  end
end
