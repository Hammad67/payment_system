class StripeCustomer
  
 def new_stripe_customer(buyer)
  stripe_cust = Stripe::Customer.create({
    email: buyer.email
  })
 end

 def charge_customer(final_amount, stripe_customer_source, customer_id)
  Stripe::Charge.create({
                          amount: final_amount.to_s,
                          currency: 'usd',
                          source: stripe_customer_source.to_s,
                          customer: customer_id.to_s,
                          description: 'Extra feature charge'
                        })
 end
end
