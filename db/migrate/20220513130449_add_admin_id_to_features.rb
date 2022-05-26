# frozen_string_literal: true

class AddAdminIdToFeatures < ActiveRecord::Migration[6.0]
  def change
    change_table :features, bulk: true do |t|
      t.integer :admin_id, foreign_key: true
      t.integer :plan_id, foreign_key: true
    end
  end
end
