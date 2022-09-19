# frozen_string_literal: true

# Add stripe customer id
class AddStripeCustIdInToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_cust_id, :string
  end
end
