# frozen_string_literal: true

class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[show edit update destroy]
  def index
    @plan = Plan.all
  end

  def new
    @buyer = Buyer.new
    authorize @buyer
  end

  def create
    @buyer = Buyer.new(user_params)
    if @buyer.save

      redirect_to @buyer
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @buyer.update(user_params)
      authorize @buyer
      stripe_cust_id = @buyer.stripe_cust_id
      StripeService.new.update_stripe_customer(stripe_cust_id, @buyer)
      InviteMailer.with(usermail: @buyer, password: @buyer.password).welcome_mail.deliver_now
      redirect_to @buyer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  def destroy
    StripeService.new.destroy_stripe_customer(@buyer)
    @buyer.destroy
    redirect_to root_path, notice: 'User was successfully destroyed.'
  end

  private

  def set_buyer
    @buyer = Buyer.find(params[:id])
  end

  def user_params
    params.require(:buyer).permit(:name, :email, :password, :avatar)
  end
end
