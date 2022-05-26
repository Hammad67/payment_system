# frozen_string_literal: true

class RemoveForeignKeyFromPlans < ActiveRecord::Migration[6.0]
  def change
    remove_column :features, :plan_id, :integer
  end
end
