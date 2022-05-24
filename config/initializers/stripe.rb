
require 'stripe'

Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['API_KEY'],
  webhook: ENV['WEBHOOK']
}
