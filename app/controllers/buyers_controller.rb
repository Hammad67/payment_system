# frozen_string_literal: true

# All buyer operations
class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[show edit update destroy]

  def index
    # @plan = Plan.all
    @buyer = Buyer.all
    render json: @buyer
  end

  def new
    @buyer = Buyer.new
    # authorize @buyer
  end

  def create
    @buyer = Buyer.new(user_params)
    # @feature.admin_id = current_user.id
    if @buyer.save
      render json: @buyer, status: :created
    else
      render json: @buyer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit; end
  
  def update
    if @buyer.update(user_params)
      # authorize @buyer
      stripe_cust_id = @buyer.stripe_cust_id
      StripeService.update_stripe_customer(stripe_cust_id, @buyer)
      InviteMailer.with(usermail: @buyer, password: @buyer.password).welcome_mail.deliver_now
      render json: @buyer, status: :created
    else
      render json: @buyer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @buyer
  end

  def destroy
    StripeService.destroy_stripe_customer(@buyer)
    if @buyer.destroy
      render json: { json: 'Buyer was successfully deleted.' }
    else
      render json: { json: @buyer.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_buyer
    @buyer = Buyer.find(params[:id])
  end

  def user_params
    params.require(:buyer).permit(:name, :email, :password, :avatar)
  end
end
