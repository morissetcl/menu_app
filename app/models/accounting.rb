class Accounting < ApplicationRecord
  validates :singleton_guard, uniqueness: true
  validates_inclusion_of :singleton_guard, in: [0]

  def self.instance
    first || new_instance
  end

  def self.new_instance
    Accounting.create!
  end
end
