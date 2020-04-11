# frozen_string_literal: true

class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :title
      t.string :price
      t.string :description
      t.references :restaurant
      t.timestamps
    end
  end
end
