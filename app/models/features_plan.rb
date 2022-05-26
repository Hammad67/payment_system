# frozen_string_literal: true

# Feature plan join model
class FeaturesPlan < ApplicationRecord
  belongs_to :feature
  belongs_to :plan
end
