# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Restopolitain::GetRestaurantMenuService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/response_restaurant_menu_restopolitain.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_menu_restopolitain) do
    stub_request(:get, 'https://www.restopolitan.es/restaurante/barcelona-162105/al-cafe-310275.html')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_menu_restopolitain
  end

  it 'Create a new restaurant_menu and dish' do
    restaurant = Restaurant.create!(name: 'creperie 21 martorell', slug: 'creperie-21-martorell')
    link = 'https://www.restopolitan.es/restaurante/barcelona-162105/al-cafe-310275.html'
    expect do
      Restopolitain::GetRestaurantMenuService.call(link, restaurant.id)
    end.to change(Dish, :count)
  end
end
