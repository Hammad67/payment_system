# frozen_string_literal: true

class AddColumnAmountInToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :amount, :integer
  end
end
