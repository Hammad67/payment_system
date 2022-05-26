# frozen_string_literal: true

class FeatureusagesController < ApplicationController
  before_action :set_featureusage, only: %i[show edit update destroy]
  before_action :set_feature, only: %i[new create]

  def index
    @featureusages = Featureusage.all
  end

  def show; end

  def new
    @featureusage = @feature.featureusages.build if @featureusage.blank?
  end

  def edit; end

  def create
    @featureusage = @feature.featureusages.new(featureusage_params)
    @featureusage.buyer_id = current_user.id
    @featureusage.plan_id = params[:featureusage][:plan_id]
    if @featureusage.save
      redirect_to feature_featureusage_path(@feature, @featureusage)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @featureusage.update(total_extra_units: (params[:featureusage][:total_extra_units]).to_s)
      redirect_to feature_featureusage_path(@feature, @featureusage)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @featureusage.destroy

    respond_to do |format|
      format.html { redirect_to featureusages_url, notice: 'Featureusage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_featureusage
    @feature = Feature.find(params[:feature_id])
    @featureusage = Featureusage.find_by(id: params[:id])
  end

  def set_feature
    @feature = Feature.find(params[:feature_id])
  end

  def featureusage_params
    params.require(:featureusage).permit(:total_extra_units)
  end
end
