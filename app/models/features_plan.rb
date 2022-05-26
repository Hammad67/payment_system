# frozen_string_literal: true

class FeaturesPlan < ApplicationRecord
  belongs_to :feature
  belongs_to :plan
end
