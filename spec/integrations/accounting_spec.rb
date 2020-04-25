# frozen_string_literal: true

require 'rails_helper'

describe Accounting, type: :model do
  # one accounting is created by default by using before(:suite) hook
  it 'is a singleton' do
    expect do
      create(:accounting)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  context 'is incremented' do
    let(:accounting) { Accounting.first }
    it 'when new dish is saved' do
      expect do
        create :dish
      end.to change{accounting.reload.dish_count}.by(1)
    end

    it 'when new restaurant is saved' do
      expect do
        create :restaurant
      end.to change{accounting.reload.restaurant_count}.by(1)
    end
  end
end
