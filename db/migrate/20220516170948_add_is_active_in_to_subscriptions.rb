# frozen_string_literal: true

# Add true false for transactions
class AddIsActiveInToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :is_active, :boolean, default: false
  end
end
