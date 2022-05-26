# frozen_string_literal: true

# All subscription related requests
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show edit update]
  def new; end

  def index
    @subscription = current_user.subscriptions.all.where(is_active: true)
  end

  def create
    if current_user.stripe_source_id.present?
      create_subscribtion(params[:plan_id]) if params[:plan_id].present?
    else
      create_customer_source(params[:stripeToken])
    end
  end

  def edit; end

  def update
    @transaction = Transaction.find_by(subscription_id: @subscription.id.to_s)
    subscription_update = StripeService.new.update_subscription(@subscription)
    @subscription.update(is_active: false, end_date: Time.zone.at(subscription_update.canceled_at))
    redirect_to buyers_path notice: 'Your Subscription is unsubscribed Successfully'
  end

  def show
    @plan_name = @subscription.plan.name
    @monthly_fee = @subscription.plan.monthly_fee
    @features = @subscription.plan.features
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def create_customer_source(token)
    customer = current_user.stripe_cust_id
    customor_source = StripeService.new.create_source(customer, token)
    if customor_source.present?
      current_user.update(stripe_source_id: customor_source.id)
      create_subscribtion(params[:plan_id]) if params[:plan_id].present?
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_subscription_path
  end

  def create_subscribtion(plan_id)
    plan = Plan.find_by(id: plan_id)
    subscription = StripeService.new.create_subscribtion(current_user, plan)
    @subscription = Subscription.create!(buyer_id: current_user.id, plan_id: plan.id,
                                         stripe_subscription_id: subscription.id,
                                         start_date: Time.zone.at(subscription.current_period_start),
                                         end_date: Time.zone.at(subscription.current_period_end),
                                         is_active: true)
    amount = @subscription.plan.monthly_fee
    @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
                                       buyer_id: @subscription.buyer_id,
                                       subscription_id: @subscription.id,
                                       amount: amount.to_s)
    redirect_to @subscription
  end
end
