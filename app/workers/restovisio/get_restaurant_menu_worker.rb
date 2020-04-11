# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Restovisio
  class GetRestaurantMenuWorker
    include Sidekiq::Worker

    def perform(link, restaurant_id)
      Restovisio::GetRestaurantMenuService.call(link, restaurant_id)
    end
  end
end
