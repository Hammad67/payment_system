# frozen_string_literal: true

# frozen_string_literal: true

# This migration comes Users
class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :name, null: false
      t.integer :users, :type, :integer, default: 0
    end
  end
end
