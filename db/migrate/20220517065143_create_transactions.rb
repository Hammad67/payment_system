# frozen_string_literal: true

# Add transactions
class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.datetime :billing_day
      t.references :buyer, foreign_key: { to_table: :users }
      t.references :subscription
      t.boolean :is_successfull, default: true
      t.timestamps
    end
  end
end
