# frozen_string_literal: true

# Added limit
class ChangeFeatureCodeFromFeatures < ActiveRecord::Migration[6.0]
  def up
    change_column :features, :code, :string, limit: 20
  end

  def down
    change_column :features, :code
  end
end
