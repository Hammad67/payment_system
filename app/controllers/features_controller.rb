class FeaturesController < ApplicationController
  before_action :set_feature, only: %i[show edit update destroy]
  def index
    @feature = Feature.all
    authorize @feature
  end

  def new
    @feature = Feature.new
    authorize @feature
  end

  def create
    @feature = Feature.new(feature_params)
    @feature.admin_id = current_user.id
    @feature.plan_id = params[:feature][:plan_id]
    respond_to do |format|
      if @feature.save
        format.html { redirect_to feature_url(@feature), notice: 'feature was successfully created.' }
        format.json { render :show, status: :created, location: @feature }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

     def edit

     end

  def update
    respond_to do |format|
      if @feature.update(feature_params)
        @feature.admin_id = current_user.id
        format.html { redirect_to feature_url(@feature), notice: 'feature was successfully updated.' }
        format.json { render :show, status: :ok, location: @feature }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to features_url, notice: 'feature was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show; end

  private

  def set_feature
    @feature = Feature.find(params[:id])
    authorize @feature
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
