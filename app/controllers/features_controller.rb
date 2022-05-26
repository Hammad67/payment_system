# frozen_string_literal: true

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
    if @feature.save
      redirect_to @feature
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    authorize @feature
    if @feature.update(feature_params)
      redirect_to feature_path(@feature)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @feature
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
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
