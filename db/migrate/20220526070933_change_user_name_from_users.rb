# frozen_string_literal: true

# Added limit
class ChangeUserNameFromUsers < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :name, :string, limit: 20
  end

  def down
    change_column :users, :name, :string
  end
end
