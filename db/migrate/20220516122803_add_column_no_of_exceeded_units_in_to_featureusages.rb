# frozen_string_literal: true

# Add exeeding units
class AddColumnNoOfExceededUnitsInToFeatureusages < ActiveRecord::Migration[6.0]
  def change
    add_column :featureusages, :no_of_exeeded_units, :integer
  end
end
