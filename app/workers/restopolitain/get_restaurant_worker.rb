# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Restopolitain
  class GetRestaurantWorker
    include Sidekiq::Worker

    def perform(*_args)
      pages = (1..43)
      pages.each do |page|
        Restopolitain::GetRestaurantService.call(page)
      end
    end
  end
end
