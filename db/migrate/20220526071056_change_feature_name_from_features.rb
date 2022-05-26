# frozen_string_literal: true

# Added limit
class ChangeFeatureNameFromFeatures < ActiveRecord::Migration[6.0]
  def up
    change_column :features, :name, :string, limit: 30
  end

  def down
    change_column :features, :name
  end
end
