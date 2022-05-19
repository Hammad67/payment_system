# frozen_string_literal: true

class Featureusage < ApplicationRecord
  belongs_to :feature
  belongs_to :buyer
  # validate :total_extra_unit
  before_update :checkvalue

  # def total_extra_unit
  #   max_unit = Feature.find_by(id: feature_id).max_unit_limit
  #   max_units = Featureusage.where(feature_id: feature_id, plan_id: plan_id, buyer_id: buyer.id).present?
  #   if max_units
  #     max_units = Featureusage.find_by(feature_id: feature_id, plan_id: plan_id,
  #                                    buyer_id: buyer.id).total_extra_units
  #     errors.add(:base, 'Please enter The value which is above maximum value') if total_extra_units < max_units
  #   elsif total_extra_units < max_unit
  #     errors.add(:base, 'Please enter The value which is above maximum value')
  #   end
  # end
  def checkvalue
    max_unit = Feature.find_by(id: feature_id).max_unit_limit
    self.no_of_exeeded_units = total_extra_units - max_unit
  end
  # def total_extra_units
  #   if feature_id.present?
  # rubocop:todo Layout/LineLength
  #     # max_unit = Featureusage.find_by(feature_id:feature_id,plan_id:self.plan_id,buyer_id:self.buyer_id).total_extra_units
  # rubocop:enable Layout/LineLength
  #     # errors.add(:base, 'Please enter The value which is above maximum value') if total_extra_units < max_unit
  #   end
  # end

  # def set_featureusage
  #   binding.pry
  #   checking_record = Featureusage.find_by(feature_id: feature_id, buyer_id: buyer_id)
  #   checking_record.update if checking_record.present?
  # end
end
