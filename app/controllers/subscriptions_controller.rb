class SubscriptionsController < ApplicationController
  def new
  end

  def create
    create_customer_source(params[:stripeToken]) unless current_user.stripe_source_id.present?
    create_subscribtion(params[:plan_id]) if params[:plan_id].present?
  end
  private
  def create_customer_source(token)
    customer=current_user.stripe_cust_id

    customor_source=Stripe::Customer.create_source(
      "#{customer}",
      {source: "#{token}"},
    )
    current_user.update(stripe_source_id: customor_source.id)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end
  def create_subscribtion(plan_id)
    plan = Plan.find_by(id: plan_id)
    binding.pry
    subscribtion = Stripe::Subscription.create({
      customer: "#{current_user.stripe_cust_id}",
      items: [
        {price: "#{plan.stripe_plan_id}"},
      ],
    })
    binding.pry
    Subscription.create(buyer_id: current_user.id, plan_id: plan.id, stripe_subscription_id: subscribtion.id)
  end
end
