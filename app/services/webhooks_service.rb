# frozen_string_literal: true

class WebhooksService
  def invoive_created(event)
    invoice_pdf = event['invoice_pdf']
    amount_due = event['amount_due']
    amount_paid = event['amount_paid']
    name = event['customer_name']
    customer_email = event['customer_email']
    buyer = Buyer.find_by(email: customer_email.to_s)
    send_invoice(buyer, invoice_pdf) if buyer.present?
  end

  def check_overuse_calculations(subscription)
    feature_extra_array = []
    subscription.plan.features.each do |feature|
      next if feature.featureusages.blank?

      feature_unit_price = feature.unit_price
      feature.featureusages.each do |feature_usage|
        next unless feature_usage.no_of_exeeded_units.present? && feature_usage.no_of_exeeded_units.positive?

        total_price_of_feature_after_overuse = feature_usage.no_of_exeeded_units * feature_unit_price
        feature_extra_array.push(total_price_of_feature_after_overuse)
      end
    end
    feature_extra_array.inject(0) { |sum, x| sum + x } if feature_extra_array.present?
  end

  def customer_subscribtion_updated_event(event)
    subscription_id = event['id']
    current_period_start = event['current_period_start']
    current_period_end = event['current_period_start']
    plan_id = event['items']['data'][0]['plan']['id']
    amount = event['items']['data'][0]['plan']['amount'] / 100
    cancel_at_period_end = event['cancel_at_period_end']
    customer_id = event['customer']
    buyer_id = Buyer.find_by(stripe_cust_id: customer_id.to_s)
    stripe_customer_source = buyer_id.stripe_source_id
    plan_id = Plan.find_by(stripe_plan_id: plan_id.to_s)
    @subscription = find_subscribtion(subscription_id, buyer_id, plan_id)
    if cancel_at_period_end.blank?
      check_cancel_period(amount)
    else
      @subscription.update(end_date: Time.zone.at(current_period_end), is_active: false)
      create_transaction(amount)
    end
    final_amount = check_overuse_calculations(@subscription)
    extra_charge = stripe_charge(final_amount, stripe_customer_source, customer_id) if final_amount.present?
    invoice_of_transaction(extra_charge, buyer_id) if final_amount.present?
  end

  def stripe_charge(final_amount, stripe_customer_source, customer_id)
    StripeService.new.charge_customer(final_amount, stripe_customer_source, customer_id)
  end

  def check_cancel_period(amount)
    @subscription.update(start_date: Time.zone.at(current_period_start), end_date: Time.zone.at(current_period_end),
                         is_active: true)
    create_transaction(amount)
  end

  def invoice_payment_failed(event)
    customer_id = event['customer']
    plan_id = event['price']['id']
    amount_due = event['amount_due']
    invoice_pdf = event['invoice_pdf']
    amount_due /= 100
    plan = Plan.find_by(stripe_plan_id: plan_id.to_s)
    buyer = Buyer.find_by(stripe_cust_id: customer_id.to_s)
    @subscription = Subscription.find_by(buyer_id: buyer.id.to_s, plan_id: plan.id.to_s)
    @subscription.update(is_active: false)
    @transaction = Transaction.create!(billing_day: @subscription.end_date, plan_id: @subscription.plan_id,
                                       buyer_id: @subscription.buyer_id, subscription_id: @subscription.id, amount: amount_due.to_s, is_successfull: false)
    send_invoice(buyer, invoice_pdf) if buyer.present?
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
