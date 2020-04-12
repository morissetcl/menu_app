# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Glovo
  class GetRestaurantWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'restaurants_glovo'

    def perform(*_args)
      paris = 'https://glovoapp.com/fr/par/category/RESTAURANT'
      Glovo::GetRestaurantGlovoService.call(paris)
    end
  end
end
