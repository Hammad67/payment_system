class AddPlanIdInToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :plan_id, :integer, foreign_key: true
  end
end
