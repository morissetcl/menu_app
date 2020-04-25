# frozen_string_literal: true

class Dish < ApplicationRecord
  belongs_to :restaurant
  validates :title, uniqueness: { scope: :restaurant_id }
  scope :source, ->(source_name) { joins(:restaurant).where(restaurants: { source: source_name }) }
  after_create { publish_to_dashboard }

  private

  def publish_to_dashboard
    Publisher.publish('dishes', attributes) unless Rails.env.test?
  end
end
