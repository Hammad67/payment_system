# frozen_string_literal: true

class FeatureusagesController < ApplicationController
  before_action :set_featureusage, only: %i[show edit update destroy]

  def index
    @featureusages = Featureusage.all
  end

  def show; end

  new
  def new
    @feature = Feature.find(params[:feature_id])
    @featureusage = @feature.featureusages.build
  end

  def edit
    @feature = Feature.find(params[:feature_id])
  end

  def create
    @feature = Feature.find(params[:feature_id])

    @featureusage = Featureusage.find_by(plan_id: (params[:featureusage][:plan_id]).to_s, feature_id: params[:feature_id].to_s,
                                         buyer_id: current_user.id.to_s)
    if @featureusage.present?
           max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
           if @featureusage.update(total_extra_units: (params[:featureusage][:total_extra_units]).to_s,
                                no_of_exeeded_units: ((params[:featureusage][:total_extra_units]).to_i - max_unit_limit).to_s)
              redirect_to feature_featureusage_path(@featureusage,params[:feature_id])
           else
            render :edit, status: :unprocessable_entity
           end
   else
      @featureusage = @feature.featureusages.new(featureusage_params)
      @featureusage.buyer_id = current_user.id
      @featureusage.plan_id = params[:featureusage][:plan_id]
      max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
      @featureusage.no_of_exeeded_units = (params[:featureusage][:total_extra_units]).to_i - max_unit_limit
      if (params[:featureusage][:total_extra_units]).to_i > max_unit_limit
        flash[:alert] =
          'You are now using the extra units create'
      end
      if @featureusage.save
        redirect_to feature_featureusage_path(@featureusage)
      else
        render :new, status: :unprocessable_entity
      end
   end
    # max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit

    # if @featureusage.present?
    #   if (params[:featureusage][:total_extra_units]).to_i < @featureusage.total_extra_units


    #     render :edit, status: :unprocessable_entity
    #   else
    #    @featureusage= Featureusage.update(total_extra_units: (params[:featureusage][:total_extra_units]).to_s,
    #                         # rubocop:todo Layout/LineLength
    #                         no_of_exeeded_units: ((params[:featureusage][:total_extra_units]).to_i - max_unit_limit).to_s)
    #     # rubocop:enable Layout/LineLength
    #     redirect_to feature_featureusage_path(@featureusage,params[:feature_id])
    #   end

    # else
    #   @featureusage = @feature.featureusages.new(featureusage_params)
    #   @featureusage.buyer_id = current_user.id
    #   @featureusage.plan_id = params[:featureusage][:plan_id]
    #   max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
    #   @featureusage.no_of_exeeded_units = (params[:featureusage][:total_extra_units]).to_i - max_unit_limit
    #   if (params[:featureusage][:total_extra_units]).to_i > max_unit_limit
    #     flash[:alert] =
    #       'You are now using the extra units create'
    #   end
    #   if @featureusage.save
    #     redirect_to feature_featureusage_path(@featureusage)
    #   else
    #     render :new, status: :unprocessable_entity
    #   end
    # end
  end

  def update
    respond_to do |format|
      if @featureusage.update(featureusage_params)
        format.html do
          redirect_to feature_featureusage_url(@featureusage), notice: 'You are using extra Feature usage.'
        end
        format.json { render :show, status: :ok, location: @featureusage }
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
