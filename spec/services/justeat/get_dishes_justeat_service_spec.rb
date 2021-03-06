# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Justeat::GetDishesService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  before(:each) do
    path = 'spec/support/files/justeat/response_restaurant_menu.html'
    @doc = Nokogiri::HTML(open(Rails.root + path))
  end

  it 'Create new dishes' do
    resto = Restaurant.create(name: 'Doudou', slug: 'doudou')
    expect do
      Justeat::GetDishesService.call(@doc, resto)
    end.to change(Dish, :count)
    first_dish = Dish.first

    expect(first_dish.restaurant).to eq resto
    expect(first_dish.price).to eq 7.80
    expect(first_dish.title).to eq 'Menu Sandwich Chicken'
  end
end
