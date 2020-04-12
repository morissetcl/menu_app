# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantMenuWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'restaurants_justeat'

    def perform(link, restaurant_slug)
      Justeat::GetRestaurantMenuService.call(link, restaurant_slug)
    end
  end
end
