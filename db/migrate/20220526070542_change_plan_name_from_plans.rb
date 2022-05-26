# frozen_string_literal: true

# Added limit
class ChangePlanNameFromPlans < ActiveRecord::Migration[6.0]
  def up
    change_column :plans, :name, :string, limit: 30
  end

  def down
    change_column :plans, :name, :string
  end
end
