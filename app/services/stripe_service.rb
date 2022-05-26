# frozen_string_literal: true

# service for stripe services
class StripeService
  def new_stripe_customer(buyer)
    stripe_cust = Stripe::Customer.create({
                                            email: buyer.email
                                          })
    buyer.update(stripe_cust_id: stripe_cust.id)
  end

  def charge_customer(final_amount, stripe_customer_source, customer_id)
    Stripe::Charge.create({
                            amount: final_amount * 100,
                            currency: 'usd',
                            source: stripe_customer_source.to_s,
                            customer: customer_id.to_s,
                            description: 'Extra feature charge'
                          })
  end

  def update_stripe_customer(stripe_cust_id, buyer)
    Stripe::Customer.update(
      stripe_cust_id.to_s,
      email: buyer.email.to_s
    )
  end

  def destroy_stripe_customer(buyer)
    Stripe::Customer.delete(buyer.stripe_cust_id.to_s)
  end

  def create_subscribtion(current_user, plan)
    Stripe::Subscription.create({
                                  customer: current_user.stripe_cust_id.to_s,
                                  items: [
                                    { price: plan.stripe_plan_id.to_s }
                                  ]
                                })
  end

  def create_source(customer, token)
    Stripe::Customer.create_source(
      customer.to_s,
      { source: token.to_s }
    )
  end

  def update_subscription(subscription)
    Stripe::Subscription.update(
      subscription.stripe_subscription_id.to_s,
      {
        cancel_at_period_end: true
      }
    )
  end

  def create_stripe_plan(monthly_fee, name)
    Stripe::Price.create({
                           unit_amount: (monthly_fee * 100).to_s,
                           currency: 'usd',
                           recurring: { interval: 'month' },
                           product_data: { name: name.to_s }
                         })
  end
end
