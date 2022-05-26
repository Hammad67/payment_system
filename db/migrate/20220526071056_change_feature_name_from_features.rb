# frozen_string_literal: true

class ChangeFeatureNameFromFeatures < ActiveRecord::Migration[6.0]
  def up
    change_column :features, :name, :string, limit: 30
  end

  def down
    change_column :features, :name
  end
end
