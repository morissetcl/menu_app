# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Restopolitain
  class GetRestaurantMenuWorker
    include Sidekiq::Worker

    def perform(link, restaurant_id)
      Restopolitain::GetRestaurantMenuService.call(link, restaurant_id)
    end
  end
end
