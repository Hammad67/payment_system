# frozen_string_literal: true

# featrue usage model
class Featureusage < ApplicationRecord
  belongs_to :feature
  belongs_to :buyer
  validates :total_extra_units, presence: true
  validate :checkvalue
  before_save :exeeded_units

  def checkvalue
    return if Featureusage.find_by(id: id).blank?

    e = Featureusage.find_by(id: id).total_extra_units
    errors.add(:base, 'Please enter The value which is above maximum value') if total_extra_units < e
  end

  def exeeded_units
    max_unit = Feature.find_by(id: feature_id).max_unit_limit
    self.no_of_exeeded_units = if total_extra_units > max_unit
                                 (total_extra_units - max_unit).abs
                               else
                                 0
                               end
  end
end
