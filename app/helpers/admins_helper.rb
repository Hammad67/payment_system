# frozen_string_literal: true

module AdminsHelper
  def checkfeatureusage(feature, subscription, buyer_id)
    Featureusage.find_by(feature_id: feature, plan_id: subscription.plan.id,
                         buyer_id: buyer_id)
  end
end
