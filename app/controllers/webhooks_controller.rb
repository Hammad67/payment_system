class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  def create # rubocop:todo Metrics/AbcSize
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = JSON.parse(payload)

    case event['type']
    when 'invoice.payment_failed'
      customer_id = event['data']['object']['customer']
      plan_id = event['data']['object']['price']['id']
      amount_due = event['data']['object']['amount_due']
      invoice_pdf = event['data']['object']['invoice_pdf']
      amount_due /= 100
      plan = Plan.find_by(stripe_plan_id: plan_id.to_s)
      buyer = Buyer.find_by(stripe_cust_id: customer_id.to_s)
      @subscription = Subscription.find_by(buyer_id: buyer.id.to_s, plan_id: plan.id.to_s)
      @subscription.update(is_active: false)
      @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
                                         buyer_id: @subscription.buyer_id, subscription_id: @subscription.id, amount: amount_due.to_s, is_successfull: false)
      send_invoice(buyer, invoice_pdf) if buyer.present?

    when 'charge.failed'

    when 'customer.subscription.updated'
      customer_subscribtion_updated_event(event)
    when 'invoice.created'
      invoive_created(event)
    end
  end

  private

  def invoive_created(event)
    invoice_pdf = event['data']['object']['invoice_pdf']
    amount_due = event['data']['object']['amount_due']
    amount_paid = event['data']['object']['amount_paid']
    name = event['data']['object']['customer_name']
    customer_email = event['data']['object']['customer_email']
    buyer = Buyer.find_by(email: customer_email.to_s)
    send_invoice(buyer, invoice_pdf) if buyer.present?
  end

  def check_overuse_calculations(subscription)
    feature_extra_array = []
    subscription[:subscription].plan.features.each do |feature|
      next unless feature.featureusages.present?

      feature_unit_price = feature.unit_price
      feature.featureusages.each do |feature_usage|
        total_extra_units = feature_usage.total_extra_units
        feature_no_of_exeeded_units = feature_usage.no_of_exeeded_units
        next unless feature_usage.no_of_exeeded_units.present? && feature_usage.no_of_exeeded_units > 0

        total_price_of_feature_after_overuse = feature_usage.no_of_exeeded_units * feature_unit_price
        feature_extra_array.push(total_price_of_feature_after_overuse)
      end
    end
    feature_extra_array.inject(0) { |sum, x| sum + x } if feature_extra_array.present?
  end

  def customer_subscribtion_updated_event(event)
    subscription_id = event['data']['object']['id']
    current_period_start = event['data']['object']['current_period_start']
    current_period_end = event['data']['object']['current_period_start']
    plan_id = event['data']['object']['items']['data'][0]['plan']['id']
    amount = event['data']['object']['items']['data'][0]['plan']['amount'] / 100
    cancel_at_period_end = event['data']['object']['cancel_at_period_end']
    customer_id = event['data']['object']['customer']
    buyer_id = Buyer.find_by(stripe_cust_id: customer_id.to_s)
    stripe_customer_source = buyer_id.stripe_source_id
    plan_id = Plan.find_by(stripe_plan_id: plan_id.to_s)
    @subscription = find_subscribtion(subscription_id, buyer_id, plan_id)
    if !cancel_at_period_end.present?
      check_cancel_period(amount)
      final_amount = check_overuse_calculations(subscription: @subscription)
      extra_charge = stripe_charge(final_amount, stripe_customer_source, customer_id) if final_amount.present?
      invoice_of_transaction(extra_charge, buyer_id) if final_amount.present?
    else
      @subscription.update(end_date: Time.zone.at(current_period_end), is_active: false)
      create_transaction(amount)
      final_amount = check_overuse_calculations(subscription: @subscription)
      extra_charge = stripe_charge(final_amount, stripe_customer_source, customer_id) if final_amount.present?
      invoice_of_transaction(extra_charge, buyer_id) if final_amount.present?
    end
  end

  def stripe_charge(final_amount, stripe_customer_source, customer_id)
    StripeCustomer.new.charge_customer(final_amount, stripe_customer_source, customer_id)
  end

  def check_cancel_period(amount)
    @subscription.update(start_date: Time.zone.at(current_period_start), end_date: Time.zone.at(current_period_end),
                         is_active: true)
    create_transaction(amount)
  end

  def invoice_of_transaction(extra_charge, buyer)
    amount_after_charge = extra_charge['amount'] / 100
    receipt = extra_charge['receipt_url']
    create_transaction(amount_after_charge)
    send_invoice(buyer, receipt)
  end

  def create_transaction(amount_after_charge)
    @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
                                       buyer_id: @subscription.buyer_id, subscription_id: @subscription.id, amount: amount_after_charge.to_s)
  end

  def send_invoice(buyer, receipt)
    InvoiceMailer.with(usermail: buyer.email, invoice: receipt).invoicemail.deliver_now
  end

  def find_subscribtion(subscription_id, buyer_id, plan_id)
    Subscription.find_by(stripe_subscription_id: subscription_id.to_s, buyer_id: buyer_id.id.to_s,
                         plan_id: plan_id.id.to_s)
  end
end
