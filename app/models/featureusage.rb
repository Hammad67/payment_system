class Featureusage < ApplicationRecord
  belongs_to :feature
  belongs_to :buyer 
  validate :max_unit_limit
  after_create :set_featureusage
  def max_unit_limit
    max_unit=Feature.find_by(id:self.feature_id).max_unit_limit
    if self.total_extra_units<max_unit
      errors.add(:base, "Please enter The value which is above maximum value")
  end
end
def set_featureusage
 max_unit_limit=Feature.find_by(id:"#{self.feature_id}").max_unit_limit
  self.update(no_of_exeeded_units:total_extra_units-max_unit_limit)
   checking_record=Featureusage.find_by(feature_id:self.feature_id,buyer_id:self.buyer_id)
   if checking_record.present?
    checking_record.destroy
end
end
end
