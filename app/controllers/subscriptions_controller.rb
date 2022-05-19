# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  count = 0 # rubocop:todo Lint/UselessAssignment
  def new; end

  def create
    #      retreive_stripe_customer=Stripe::Customer.retrieve("#{current_user.stripe_cust_id}")
    #       plan=Plan.find_by(params[:plan_id])
    #       if retreive_stripe_customer.balance< plan.monthly_fee
    #         flash[:alert]="Your account balance is insufficent for this request"
    #         redirect_to buyers_path
    # end
    if current_user.stripe_source_id.present?
      create_subscribtion(params[:plan_id]) if params[:plan_id].present?
    else
      create_customer_source(params[:stripeToken])
    end
  end

  def edit
    @subscription = Subscription.find(params[:id])
  end

  def update # rubocop:todo Metrics/AbcSize
    @subscription = Subscription.find(params[:id])
    @transaction = Transaction.find_by(subscription_id: @subscription.id.to_s)
    subscription_update = Stripe::Subscription.update(
      @subscription.stripe_subscription_id.to_s,
      {
        cancel_at_period_end: true
      }
    )
    @subscription.update(is_active: false, end_date: Time.zone.at(subscription_update.canceled_at))
    @transaction.update(billing_day: @subscription.end_date)
    redirect_to buyers_path notice: 'Your Subscription is unsubscribed Successfully'
  end

  def show
    @subscription = Subscription.find(params[:id])
    @plan_name = @subscription.plan.name
    @monthly_fee = @subscription.plan.monthly_fee
    @features = @subscription.plan.features
  end

  private

  def create_customer_source(token) # rubocop:todo Metrics/AbcSize
    customer = current_user.stripe_cust_id

    customor_source = Stripe::Customer.create_source(
      customer.to_s,
      { source: token.to_s }
    )
    if customor_source.present?
      current_user.update(stripe_source_id: customor_source.id)
      create_subscribtion(params[:plan_id]) if params[:plan_id].present?
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end

  def create_subscribtion(plan_id) # rubocop:todo Metrics/AbcSize
    plan = Plan.find_by(id: plan_id)

    subscription = Stripe::Subscription.create({
                                                 customer: current_user.stripe_cust_id.to_s,
                                                 items: [
                                                   { price: plan.stripe_plan_id.to_s }
                                                 ]
                                               })
    @subscription = Subscription.create!(buyer_id: current_user.id, plan_id: plan.id,
                                         # rubocop:todo Layout/LineLength
                                         stripe_subscription_id: subscription.id, start_date: Time.zone.at(subscription.current_period_start), end_date: Time.zone.at(subscription.current_period_end), is_active: true)
    # rubocop:enable Layout/LineLength
    @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
                                       buyer_id: @subscription.buyer_id, subscription_id: @subscription.id)
    redirect_to @subscription
  end
end
