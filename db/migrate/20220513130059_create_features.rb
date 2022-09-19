# frozen_string_literal: true

# Add table features
class CreateFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :features do |t|
      t.string :name, unique: true, null: false
      t.string :code, unique: true, null: false
      t.integer :unit_price, null: false
      t.integer :max_unit_limit, null: false

      t.timestamps
    end
  end
end
