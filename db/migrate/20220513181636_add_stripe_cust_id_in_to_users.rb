# frozen_string_literal: true

class AddStripeCustIdInToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_cust_id, :string
  end
end
