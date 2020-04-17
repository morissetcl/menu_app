# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :dishes

  validates :name, :slug, uniqueness: true

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
end
