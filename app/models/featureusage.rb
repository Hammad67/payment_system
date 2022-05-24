# frozen_string_literal: true

class Featureusage < ApplicationRecord
  belongs_to :feature
  belongs_to :buyer
  validates :total_extra_units, presence: true
  validate :checkvalue
  before_save :exeeded_units

  def checkvalue
    if Featureusage.find_by(id: id).present?
      e = Featureusage.find_by(id: id).total_extra_units
      errors.add(:base, 'Please enter The value which is above maximum value') if total_extra_units < e
    end
  end
    def exeeded_units
      max_unit = Feature.find_by(id: feature_id).max_unit_limit
      self.no_of_exeeded_units = (total_extra_units - max_unit).abs
    end
  end
