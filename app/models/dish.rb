# frozen_string_literal: true

class Dish < ApplicationRecord
  belongs_to :restaurant
  validates :title, uniqueness: { scope: :restaurant_id }
  scope :source, ->(source_name) { joins(:restaurant).where(restaurants: { source: source_name }) }
end
