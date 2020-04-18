# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Justeat::GetRestaurantService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/justeat/response_restaurant.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_justeat) do
    stub_request(:get, 'https://www.just-eat.fr/livraison/paris/paris')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  let(:stub_restaurant_justeat_page_2) do
    stub_request(:get, 'https://www.just-eat.fr/livraison/paris/paris?page=2')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_justeat
    stub_restaurant_justeat_page_2
  end

  it 'Extract datas to create restaurants' do
    expect do
      Justeat::GetRestaurantService.call('https://www.just-eat.fr/livraison/paris/paris')
    end.to change(Restaurant, :count)

    first_restaurant = Restaurant.first
    expect(first_restaurant.name).to eq 'La Pause Braisée'
    expect(first_restaurant.street).to eq '64b Rue Jean Jaurès'
    expect(first_restaurant.source).to eq 'justeat'
  end

  it 'Call GetRestaurantMenuWorker' do
    expect do
      Justeat::GetRestaurantService.call('https://www.just-eat.fr/livraison/paris/paris')
    end.to change(Justeat::GetRestaurantMenuWorker.jobs, :size).by(22)
    # there is 11 restaurants by page and 2 pages in the support file
  end
end
