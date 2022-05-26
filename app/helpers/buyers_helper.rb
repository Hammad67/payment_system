# frozen_string_literal: true

# used all buyer queries here
module BuyersHelper
  def check_subscription_existence(plan_id)
    current_user.subscriptions.where(is_active: true).find_by(plan_id:
      plan_id.to_s).present? && current_user.type == 'Buyer'
  end

  def find_subscription(plan_id)
    current_user.subscriptions.where(is_active: true).find_by(plan_id: plan_id.to_s)
  end
end
