# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Justeat::GetRestaurantService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/justeat/response_restaurant.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_justeat) do
    stub_request(:get, 'https://www.just-eat.fr/livraison/paris/paris/?page=19')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_justeat
  end

  it 'Create a new restaurant and launch new worker' do
    expect do
      Justeat::GetRestaurantService.call(19)
    end.to change(Restaurant, :count)
  end
end
