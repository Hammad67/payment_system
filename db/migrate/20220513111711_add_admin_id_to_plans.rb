class AddAdminIdToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :admin_id, :integer ,foreign_key: true
  end
end
