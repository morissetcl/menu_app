# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :dishes
  after_create { publish_to_dashboard }

  validates :name, uniqueness: true

  def from_justeat?
    source == 'justeat'
  end

  def from_deliveroo?
    source == 'deliveroo'
  end

  def from_foodin?
    source == 'foodin'
  end

  def from_glovo?
    source == 'glovo'
  end

  def from_restopolitain?
    source == 'restopolitain'
  end

  private

  def publish_to_dashboard
    Publisher.publish('restaurants', attributes)
  end
end
