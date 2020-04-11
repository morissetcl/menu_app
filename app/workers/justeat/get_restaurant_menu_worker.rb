# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantMenuWorker
    include Sidekiq::Worker

    def perform(link, restaurant_slug)
      Justeat::GetRestaurantMenuService.call(link, restaurant_slug)
    end
  end
end
