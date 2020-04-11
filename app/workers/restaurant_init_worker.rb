# frozen_string_literal: true

require 'sidekiq-scheduler'

class RestaurantInitWorker
  include Sidekiq::Worker

  def perform(*args)
    Justeat::GetRestaurantWorker.perform_async(*args)
    Deliveroo::GetRestaurantWorker.perform_async(*args)
    Foodin::GetRestaurantWorker.perform_async(*args)
    Restopolitain::GetRestaurantWorker.perform_async(*args)
    Glovo::GetRestaurantWorker.perform_async(*args)
    Restovisio::GetRestaurantWorker.perform_async(*args)
  end
end
