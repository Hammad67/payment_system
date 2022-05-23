class TransactionsController < ApplicationController
  def index
    @transaction=Transaction.all
  end
end
