# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  def create
    case event['type']
    when 'invoice.payment_failed'
      WebhooksService.new.invoice_payment_failed(event)

    when 'customer.subscription.updated'
      WebhooksService.new.customer_subscribtion_updated_event(event)
    when 'invoice.created'
      WebhooksService.new.invoive_created(event)
    end
  end

  private

  def event
    @event ||= JSON.parse(request.body.read)
  end
end
