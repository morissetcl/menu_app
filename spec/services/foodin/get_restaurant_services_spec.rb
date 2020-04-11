# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Foodin::GetRestaurantFoodinService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/foodin/response_restaurant.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_foodin) do
    stub_request(:get, 'https://foodin.fr/nos-restaurants/Orl%C3%A9ans')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_foodin
  end

  it 'Create a new restaurant and launch new worker' do
    expect do
      Foodin::GetRestaurantFoodinService.call('Orl%C3%A9ans')
    end.to change(Restaurant, :count)
  end
end
