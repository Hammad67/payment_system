# frozen_string_literal: true

class AddStartDateInToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    change_table :subscriptions, bulk: true do |t|
      t.datetime :start_date
      t.datetime :end_date
    end
  end
end
