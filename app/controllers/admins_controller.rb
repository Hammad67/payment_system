# frozen_string_literal: true

# frozen_string_literal: true

class AdminsController < ApplicationController
  def index
    @subscription = Subscription.all
    authorize @subscription
    @transaction = Transaction.all
    authorize @transaction
  end
end
