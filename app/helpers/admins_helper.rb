module AdminsHelper
  def checkfeatureusage(feature, subscription, buyer_id: subscription.buyer.id)
    feature_extract = Featureusage.find_by(feature_id: feature, plan_id: subscription.plan.id,
                                           buyer_id: subscription.buyer.id)
  end
end
