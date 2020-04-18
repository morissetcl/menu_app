# frozen_string_literal: true

require 'rails_helper'

describe Dish, type: :integration do
  let(:restaurant_glovo) { create :restaurant, name: 'Pwasson', source: 'glovo' }
  let(:restaurant_justeat) { create :restaurant, name: 'Vyande', source: 'justeat' }
  let(:dish_glovo) { create :dish, title: 'Fish & chips', restaurant: restaurant_glovo }
  let(:dish_justeat) { create :dish, title: 'Meat & chips', restaurant: restaurant_justeat }

  context 'scopes' do
    it '#source' do
      expect(Dish.source('glovo')).to eq([dish_glovo])
    end
  end
end
