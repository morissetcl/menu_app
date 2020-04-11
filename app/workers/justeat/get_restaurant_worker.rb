# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Justeat
  class GetRestaurantWorker
    include Sidekiq::Worker

    def perform(*_args)
      pages = (1..19)
      pages.each do |page|
        Justeat::GetRestaurantService.call(page)
        sleep 3 unless Rails.env.test?
      end
    end
  end
end
