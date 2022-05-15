class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_subscription_id
      t.references :plan,     null: false
      t.references :buyer, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
