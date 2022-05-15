Rails.configuration.stripe = {
    :publishable_key => ENV['PUBLISHABLE_KEY'],
    :secret_key      => ENV['API_KEY']
  }
  
  Stripe.api_key = Rails.configuration.stripe[:secret_key]