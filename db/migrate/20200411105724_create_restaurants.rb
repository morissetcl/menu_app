# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :slug
      t.string :city
      t.string :zip_code
      t.string :street
      t.string :department
      t.string :tags, :text, array: true, default: []
      t.float :latitude
      t.float :longitude
      t.string :source
      t.string :address
      t.timestamps
    end
  end
end
