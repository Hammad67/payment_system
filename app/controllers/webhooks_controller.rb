class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  def create # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
  payload = request.body.read
  sig_header = request.env['HTTP_STRIPE_SIGNATURE']
  event = JSON.parse(payload)
  # begin
  # event = Stripe::Webhook.construct_event(
  # payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook)
  # )
  # rescue JSON::ParserError => e
  # status 400
  # return
  # rescue Stripe::SignatureVerificationError => e
  # # Invalid signatucharge.failedre
  # Rails.logger.debug 'Signature error'
  # Rails.logger.debug e
  # return
  # end
  # Handle the event
  case event["type"]
  when 'invoice.payment_failed'
  customer_id=event["data"]["object"]["id"]
  when 'charge.failed'
  binding
  when 'customer.subscription.updated'
  subscription_id=event["data"]["object"]["id"]
  current_period_start= event["data"]["object"]["current_period_start"]
  current_period_end= event["data"]["object"]["current_period_start"]
  plan_id=event["data"]["object"]["items"]["data"][0]["plan"]["id"]
  amount=event["data"]["object"]["items"]["data"][0]["plan"]["amount"]
  amount=amount/100
  cancel_at_period_end=event["data"]["object"]["cancel_at_period_end"]
  customer_id=event["data"]["object"]["customer"]
  buyer_id=Buyer.find_by(stripe_cust_id:"#{customer_id}")
  stripe_customer_source=buyer_id.stripe_source_id
  plan_id=Plan.find_by(stripe_plan_id:"#{plan_id}")
  @subscription=Subscription.find_by(stripe_subscription_id:"#{subscription_id}",buyer_id:"#{buyer_id.id}",plan_id:"#{plan_id.id}")
  if !cancel_at_period_end.present?
  @subscription.update( start_date: Time.zone.at(current_period_start), end_date: Time.zone.at(current_period_end), is_active: true)
  @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
  buyer_id: @subscription.buyer_id, subscription_id: @subscription.id,amount:"#{amount}")
  final_amount=check_overuse_calculations(subscription:@subscription)
  if final_amount.present?
  extra_charge=charge_customer(final_amount,stripe_customer_source,customer_id)
  amount_after_charge=extra_charge["amount"]
  amount_after_charge=amount_after_charge/100
  receipt=extra_charge["receipt_url"]
  @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
  buyer_id: @subscription.buyer_id, subscription_id: @subscription.id,amount:"#{amount_after_charge}")
  InvoiceMailer.with(usermail: buyer.email,invoice:receipt).invoicemail.deliver_now
  end
  else
  @subscription.update(end_date: Time.zone.at(current_period_end), is_active: false)
  @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
  buyer_id: @subscription.buyer_id, subscription_id: @subscription.id,amount:"#{amount}")
  final_amount= check_overuse_calculations(subscription:@subscription)
  if final_amount.present?
  extra_charge=charge_customer(final_amount,stripe_customer_source,customer_id)
  amount_after_charge=extra_charge["amount"]
  amount_after_charge=amount_after_charge/100
  receipt=extra_charge["receipt_url"]
  InvoiceMailer.with(usermail: buyer.email,invoice:receipt).invoicemail.deliver_now
  @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
  buyer_id: @subscription.buyer_id, subscription_id: @subscription.id,amount:"#{amount_after_charge}")
  end
  end
  when 'invoice.created'
  invoice_pdf=event["data"]["object"]["invoice_pdf"]
  amount_due=event["data"]["object"]["amount_due"]
  amount_paid=event["data"]["object"]["amount_paid"]
  name=event["data"]["object"]["customer_name"]
  customer_email=event["data"]["object"]["customer_email"]
  buyer=Buyer.find_by(email:"#{customer_email}")
  if buyer.present?
  InvoiceMailer.with(usermail: buyer.email,invoice:invoice_pdf).invoicemail.deliver_now
  end
  end
  end
  def charge_customer(final_amount,stripe_customer_source,customer_id)
  binding.pry
  extra_charge=Stripe::Charge.create({
  amount: "#{final_amount}",
  currency: 'usd',
  source: "#{stripe_customer_source}",
  customer: "#{customer_id}",
  description: 'Extra feature charge',
  })
  return extra_charge
  end
  def check_overuse_calculations(subscription)
  feature_extra_array = []
  subscription[:subscription].plan.features.each do |feature|
  if feature.featureusages.present?
  feature_name=feature.name
  feature_unit_price=feature.unit_price
  feature.featureusages.each do |feature_usage|
  total_extra_units=feature_usage.total_extra_units
  feature_no_of_exeeded_units=feature_usage.no_of_exeeded_units
  total_price_of_feature_after_overuse=feature_usage.no_of_exeeded_units*feature_unit_price

  # overuse_feature={name: "#{feature_name}",total_price_of_feature_after_overuse: "#{total_price_of_feature_after_overuse}"}
  # feature_extra_array.push(overuse_feature)

  feature_extra_array.push(total_price_of_feature_after_overuse)
  end
  end
  end
  if feature_extra_array.present?

  final_amount=feature_extra_array.inject(0){|sum,x| sum + x }
  return final_amount
  end
  end
  end

