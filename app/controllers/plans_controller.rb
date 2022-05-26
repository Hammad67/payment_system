# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :create_plan, only: %i[create]

  def index
    @plans = Plan.all
    authorize @plans
  end

  def show; end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def edit; end

  def create
    @plan = @feature.plans.create(plan_params)
    if @plan.save
      authorize @plan
      redirect_to plan_path(@plan)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        @plan.admin_id = current_user.id
        format.html { redirect_to plan_url(@plan), notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def create_plan
    @feature = Feature.find_by(id: params[:plan][:feature_ids].to_s)
  end

  def set_plan
    @plan = Plan.find(params[:id])
    authorize @plan
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee)
  end
end
