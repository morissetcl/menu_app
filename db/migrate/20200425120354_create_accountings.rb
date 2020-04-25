class CreateAccountings < ActiveRecord::Migration[6.0]
  def change
    create_table :accountings do |t|
      t.integer :dish_count, default: 0
      t.integer :restaurant_count, default: 0
      t.integer :singleton_guard, default: 0

      t.timestamps
    end

    add_index(:accountings, :singleton_guard, unique: true)
  end
end
