
class AdminsController < ApplicationController
  def index
    @subscription = Subscription.all
    authorize @subscription
    @transaction = Transaction.all
    authorize @transaction
  end
end
