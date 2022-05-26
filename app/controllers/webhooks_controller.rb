# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  def create
    case event['type']
    when 'invoice.payment_failed'
      WebhooksService.new.invoice_payment_failed(event['data']['object'])

    when 'customer.subscription.updated'
      WebhooksService.new.customer_subscribtion_updated_event(event['data']['object'])
    when 'invoice.created'
      WebhooksService.new.invoive_created(event['data']['object'])
    end
  end

  private

  def event
    @event ||= JSON.parse(request.body.read)
  end
end
