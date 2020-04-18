# frozen_string_literal: true

require 'rails_helper'

describe Restaurant, type: :model do
  it { should validate_uniqueness_of :slug }
  it { should validate_uniqueness_of :name }
end
