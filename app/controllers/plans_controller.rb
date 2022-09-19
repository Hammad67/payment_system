# frozen_string_literal: true

# The plan page of our apllication
class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]
  before_action :create_plan, only: %i[create]


  def index
    @planfeature = []
    @plans = Plan.all
    @plans.each do |plan|
      # authorize @plans
      @planfeature.push(id: plan.id, name: plan.name, monthly_fee: plan.monthly_fee, plan_features: plan.features)
    end
    render json: { plan: @plans, planfeature: @planfeature }
  end

  def show
    render json: @plan
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def edit; end

  def create
    @plan = @feature.plans.create(plan_params)
    if @plan.save
      render json: @plan, status: :created
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: @plan, status: :created
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def destroy
   
    if @plan.destroy
      render json: { json: 'plan was successfully deleted.' }
    else
      render json: { json: @plan.errors, status: :unprocessable_entity }
    end
  end

  private

  def create_plan
    @feature = Feature.find_by(id: params[:plan][:feature_ids].to_s)
  end

  def set_plan
    @plan = Plan.find(params[:id])
    # authorize @plan
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee)
  end
end
