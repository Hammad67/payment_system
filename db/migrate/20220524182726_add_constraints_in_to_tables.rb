class AddConstraintsInToTables < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :name, :string, limit: 10
    change_column :plans, :name, :string, limit: 30
    change_column :features, :name, :string, limit: 30
    change_column :features, :code, :string, limit: 20
  end
end
