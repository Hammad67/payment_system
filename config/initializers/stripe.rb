# frozen_string_literal: true

require 'stripe'

Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['API_KEY'],
  webhook: ENV['WEBHOOK']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.application.credentials.stripe[:webhook]
StripeEvent.configure do |events|
  events.subscribe 'invoice.paid' do |event|
    InvoiceMailer.with({ "customer_email": event.data.object.customer_email }).order_successful_email.deliver_now
  end
end
