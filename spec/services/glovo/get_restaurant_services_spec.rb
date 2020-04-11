# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Glovo::GetRestaurantGlovoService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/glovo/response_restaurant.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_glovo) do
    stub_request(:get, 'https://glovoapp.com/fr/shz/category/RESTAURANT')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_glovo
  end

  it 'Create a new restaurant and launch new worker' do
    address = 'https://glovoapp.com/fr/shz/category/RESTAURANT'
    expect do
      Glovo::GetRestaurantGlovoService.call(address)
    end.to change(Restaurant, :count)
  end
end
