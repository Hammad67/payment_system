class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name,null: false
      t.integer :monthly_fee, null: false

      t.timestamps
    end
  end
end
