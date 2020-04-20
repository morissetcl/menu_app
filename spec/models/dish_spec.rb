# frozen_string_literal: true

require 'rails_helper'

describe Dish, type: :model do
  it { should validate_uniqueness_of(:title).scoped_to(:restaurant_id) }
end
