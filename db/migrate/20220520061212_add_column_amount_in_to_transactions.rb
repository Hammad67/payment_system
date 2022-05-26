# frozen_string_literal: true

# Remove integer
class AddColumnAmountInToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :amount, :integer
  end
end
