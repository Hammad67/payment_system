class PlansController < ApplicationController
  before_action :set_plan, only: %i[show edit update destroy]

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
    @plan = Plan.new(plan_params)
    authorize @plan
    @plan.admin_id = current_user.id
    respond_to do |format|
      if @plan.save
        format.html { redirect_to plan_url(@plan), notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
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

  def set_plan
    @plan = Plan.find(params[:id])
    authorize @plan
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee)
  end
end
