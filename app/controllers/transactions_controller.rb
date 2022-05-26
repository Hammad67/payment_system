# frozen_string_literal: true

# All transactions related requests
class TransactionsController < ApplicationController
  def index
    @transaction = Transaction.all
    authorize @transaction
  end
end
