# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Foodin
  class GetRestaurantMenuWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'menu_foodin'

    def perform(link, restaurant_id)
      Foodin::GetRestaurantMenuFoodinService.call(link, restaurant_id)
    end
  end
end
