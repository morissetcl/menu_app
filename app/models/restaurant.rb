# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :dishes
  after_create { publish_to_dashboard }

  validates :name, uniqueness: true

  def from(source_name)
    source == source_name
  end

  private

  def publish_to_dashboard
    Publisher.publish('restaurants', attributes) unless Rails.env.test?
  end
end
