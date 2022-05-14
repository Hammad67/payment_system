class AddStripePlanIdInToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :stripe_plan_id, :string
  end
end
