class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  def subscription_create # rubocop:todo Metrics/AbcSize, Metrics/MethodLength
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook)
      )
    rescue JSON::ParserError => e
      status 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      Rails.logger.debug 'Signature error'
      Rails.logger.debug e
      return
    end

    # Handle the event
    case event.type
    when 'customer.create'
      binding.pry # rubocop:todo Lint/Debugger
    when 'customer.subscription.updated'
      Rails.logger.debug '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      binding.pry # rubocop:todo Lint/Debugger
      subscription = event.data.object
      @user = User.fby(stripe_customer_id: subscription.customer)
      @user.update(
        subscription_status: subscription.status,
        plan: subscription.items.data[0].price.lookup_key
      )
    end

    render json: { message: 'success' }
  end
  # rubocop:enable Metrics/MethodLength
end
