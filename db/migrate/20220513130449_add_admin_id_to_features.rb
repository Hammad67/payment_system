# frozen_string_literal: true

class AddAdminIdToFeatures < ActiveRecord::Migration[6.0]
  def change
    add_column :features, :admin_id, :integer, foreign_key: true
    add_column :features, :plan_id, :integer, foreign_key: true
  end
end
