# frozen_string_literal: true

module BuyersHelper
  def check_subscription_existence(plan_id)
    find_result=current_user.subscriptions.where(is_active:true).find_by(plan_id:"#{plan_id}").present? && current_user.type=="Buyer"
  end
  def find_subscription(plan_id)
    subscription=current_user.subscriptions.where(is_active:true).find_by(plan_id:"#{plan_id}")
  end

end
