# frozen_string_literal: true

require 'stripe'

Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['API_KEY'],
  webhook: ENV['WEBHOOK']
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
