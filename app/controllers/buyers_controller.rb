# frozen_string_literal: true

# All buyer operations
class BuyersController < ApplicationController
  before_action :set_buyer, only: %i[show edit update destroy]

  def index
    # @plan = Plan.all
    @buyer = Buyer.all
    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @buyer }
    end
  end

  def new
    @buyer = Buyer.new
    # authorize @buyer
  end

  def create
    @buyer = Buyer.new(user_params)
    # @feature.admin_id = current_user.id
    respond_to do |format|
      if @buyer.save
        format.html { redirect_to @buyer, notice: 'Buyer was successfully created.' }
        format.json { render json: @buyer, status: :created }
      else
        format.html { render :new }
        format.json { render json: @buyer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit; end
  
  def update
    respond_to do |format|
      if @buyer.update(user_params)
        # authorize @buyer
        stripe_cust_id = @buyer.stripe_cust_id
        StripeService.update_stripe_customer(stripe_cust_id, @buyer)
        InviteMailer.with(usermail: @buyer, password: @buyer.password).welcome_mail.deliver_now
        format.html { redirect_to @buyer, notice: 'Buyer was successfully updated.' }
        format.json { render json: @buyer, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @buyer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: @buyer }
    end
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
