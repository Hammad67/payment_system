class SubscriptionsController < ApplicationController
  def new
  end

  def create
#      retreive_stripe_customer=Stripe::Customer.retrieve("#{current_user.stripe_cust_id}")
#       plan=Plan.find_by(params[:plan_id])
#       if retreive_stripe_customer.balance< plan.monthly_fee
#         flash[:alert]="Your account balance is insufficent for this request" 
#         redirect_to buyers_path 
# end
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

    subscription = Stripe::Subscription.create({
      customer: "#{current_user.stripe_cust_id}",
      items: [
        {price: "#{plan.stripe_plan_id}"},
      ],
    })

    @subscription=Subscription.create!(buyer_id: current_user.id, plan_id: plan.id, stripe_subscription_id: subscription.id,start_date:Time.at(subscription.current_period_start) ,end_date:Time.at(subscription.current_period_end),is_active:true)
    redirect_to @subscription
    def update
      @subscription=Subscription.find(params[:id])
      @subscription.update(is_active:false)
      redirect_to buyers_path notice: "Your Subscription is unsubscribed Successfully" 
    end
    def show
      binding.pry
      @subscription=Subscription.find(params[:id])
      @plan_name=@subscription.plan.name
      @monthly_fee=@subscription.plan.monthly_fee
      @features= @subscription.plan.features
    end
  end
end
