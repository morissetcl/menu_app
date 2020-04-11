# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Deliveroo::GetRestaurantService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  before(:each) do
    @doc = Nokogiri::HTML(File.open(Rails.root + 'spec/support/files/deliveroo/response.html'))
  end

  it 'Create a new restaurant and launch new worker' do
    expect do
      Deliveroo::GetRestaurantService.call(@doc)
    end.to change { Restaurant.count }
      .and change(Deliveroo::GetRestaurantMenuWorker.jobs, :size).by(1)
  end
end
