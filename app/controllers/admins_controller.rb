
class AdminsController < ApplicationController
  def index
    @subscription = Subscription.all
    @transaction = Transaction.all
  end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  def show; end
end
