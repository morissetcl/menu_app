# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Deliveroo
  class GetRestaurantMenuWorker
    include Sidekiq::Worker

    def perform(link, restaurant_slug)
      Deliveroo::GetRestaurantMenuService.call(link, restaurant_slug)
    end
  end
end
