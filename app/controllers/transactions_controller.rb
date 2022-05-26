# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    @transaction = Transaction.all
    authorize @transaction
  end
end
