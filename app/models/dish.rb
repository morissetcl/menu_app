# frozen_string_literal: true

class Dish < ApplicationRecord
  belongs_to :restaurant

  scope :source, ->(source_name) { joins(:restaurant).where(restaurants: { source: source_name }) }
end
