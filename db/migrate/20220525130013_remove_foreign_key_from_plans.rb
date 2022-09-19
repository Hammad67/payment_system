# frozen_string_literal: true

# Remove plan_id
class RemoveForeignKeyFromPlans < ActiveRecord::Migration[6.0]
  def change
    remove_column :features, :plan_id, :integer
  end
end
