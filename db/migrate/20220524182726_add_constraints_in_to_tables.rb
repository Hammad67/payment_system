class AddConstraintsInToTables < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :name, :string, limit: 10
  end
end
