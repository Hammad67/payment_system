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
    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: { plan: @plans, planfeature: @planfeature } }
    end
  end

  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: @plan }
    end
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def edit; end

  def create
    @plan = @feature.plans.create(plan_params)
    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: 'Plan was successfully created.' }
        format.json { render json: @plan, status: :created }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        format.json { render json: @plan, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @plan.destroy
        format.html { redirect_to plans_url, notice: 'Plan was successfully deleted.' }
        format.json { render json: { json: 'plan was successfully deleted.' } }
      else
        format.html { redirect_to plans_url, alert: 'Failed to delete plan.' }
        format.json { render json: { json: @plan.errors, status: :unprocessable_entity } }
      end
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
