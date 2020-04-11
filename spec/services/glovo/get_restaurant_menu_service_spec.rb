# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Glovo::GetRestaurantMenuGlovoService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/glovo/response_restaurant_menu.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_menu_glovo) do
    stub_request(:get, 'https://glovoapp.com/fr/shz/store/semsema-2/')
      .to_return(status: 200, body: reponse_body, headers: {})
  end

  before do
    stub_restaurant_menu_glovo
  end

  it 'Create dishes' do
    link = '/fr/shz/store/semsema-2/'
    restaurant = Restaurant.create(name: 'semsema 2', slug: 'semsema-2')
    expect do
      Glovo::GetRestaurantMenuGlovoService.call(restaurant.id, link)
    end.to change(Dish, :count)
  end
end
