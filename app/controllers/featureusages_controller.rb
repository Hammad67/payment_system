# frozen_string_literal: true

class FeatureusagesController < ApplicationController
  before_action :set_featureusage, only: %i[show edit update destroy]

  def index
    @featureusages = Featureusage.all
  end

  def show; end

  def new
    @feature = Feature.find(params[:feature_id])
    @featureusage = @feature.featureusages.build if !@featureusage.present?
  end

  def edit
    @feature = Feature.find(params[:feature_id])
    @featureusage = Featureusage.find_by(id: params[:id])
  end

  def create
      @feature = Feature.find(params[:feature_id])
      @featureusage = @feature.featureusages.new(featureusage_params)
      @featureusage.buyer_id = current_user.id
      @featureusage.plan_id = params[:featureusage][:plan_id]
      max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
      @featureusage.no_of_exeeded_units = (params[:featureusage][:total_extra_units]).to_i - max_unit_limit
      respond_to do |format|
        if @featureusage.save
          format.html { redirect_to feature_featureusage_url(@feature, @featureusage), notice: 'Plan was successfully updated.' }
          format.json { render :show, status: :created, location:  @featureusage }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @featureusage.errors, status: :unprocessable_entity }
        end
      end
  end

  def update
    @feature = Feature.find(params[:feature_id])
    @featureusage = Featureusage.find_by(id: params[:id])
    respond_to do |format|
      max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
      # no_of_exeeded_units = params[:featureusage][:total_extra_units].to_i - max_unit_limit if params[:featureusage][:total_extra_units].to_i - max_unit_limit > 0
      if @featureusage.update(total_extra_units: (params[:featureusage][:total_extra_units]).to_s)
        flash[:noice] = 'You are now using the extra units create'
        format.html { redirect_to feature_featureusage_url(@feature, @featureusage), notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location:  @featureusage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @featureusage.errors, status: :unprocessable_entity }
      end
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
    @featureusage = Featureusage.find(params[:id])
  end

  def featureusage_params
    params.require(:featureusage).permit(:total_extra_units)
  end
end
