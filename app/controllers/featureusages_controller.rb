class FeatureusagesController < ApplicationController
  before_action :set_featureusage, only: %i[show edit update destroy]
  before_action :set_feature, only: %i[new create]

  def index
    @featureusages = Featureusage.all
  end

  def show; end

  def new
    binding.pry
    @featureusage = @feature.featureusages.build unless @featureusage.present?
  end

  def edit; end

  def create
    @featureusage = @feature.featureusages.new(featureusage_params)
    @featureusage.buyer_id = current_user.id
    @featureusage.plan_id = params[:featureusage][:plan_id]
    max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
    respond_to do |format|
      if @featureusage.save
        format.html do
          redirect_to feature_featureusage_url(@feature, @featureusage),
                      notice: 'Feature usage was successfully updated.'
        end

        format.json { render :show, status: :created, location:  @featureusage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @featureusage.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      max_unit_limit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
      if @featureusage.update(total_extra_units: (params[:featureusage][:total_extra_units]).to_s)
        flash[:noice] = 'You are now using the extra units create'
        format.html do
          redirect_to feature_featureusage_url(@feature, @featureusage),
                      notice: 'Feature usage was successfully updated.'
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
