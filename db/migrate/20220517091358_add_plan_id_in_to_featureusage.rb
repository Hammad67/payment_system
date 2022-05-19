# frozen_string_literal: true

class AddPlanIdInToFeatureusage < ActiveRecord::Migration[6.0]
  def change
    add_column :featureusages, :plan_id, :integer, foreign_key: true
  end
end