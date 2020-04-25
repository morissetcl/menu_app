# frozen_string_literal: true

class Accounting < ApplicationRecord
  validates :singleton_guard, uniqueness: true
  validates_inclusion_of :singleton_guard, in: [0]
  after_save { publish_to_dashboard }

  def self.instance
    first || new_instance
  end

  def self.new_instance
    Accounting.create!
  end

  private

  def publish_to_dashboard
    Publisher.publish('accounting', attributes) unless Rails.env.test?
  end
end
