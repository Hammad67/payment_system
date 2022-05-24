# frozen_string_literal: true

class AddStartDateInToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :start_date, :datetime
    add_column :subscriptions, :end_date, :datetime
  end
end
