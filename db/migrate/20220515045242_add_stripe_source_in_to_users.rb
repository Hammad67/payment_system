class AddStripeSourceInToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_source_id, :string
  end
end
