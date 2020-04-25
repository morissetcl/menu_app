# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :dishes
  after_save { publish_to_dashboard }

  validates :name, uniqueness: true

  def from(source_name)
    source == source_name
  end

  private

  def publish_to_dashboard
    Accounting.first.update(restaurant_count: Accounting.first.restaurant_count + 1)
    return if city.blank? || Rails.env.test?

    Publisher.publish('restaurants', attributes)
  end
end
