# frozen_string_literal: true

# Add featureusage table
class CreateFeatureusages < ActiveRecord::Migration[6.0]
  def change
    create_table :featureusages do |t|
      t.integer :total_extra_units
      t.boolean :is_used
      t.references :feature, null: false, foreign_key: true
      t.references :buyer, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
