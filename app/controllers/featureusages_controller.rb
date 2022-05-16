class FeatureusagesController < ApplicationController
  before_action :set_featureusage, only: %i[show edit update destroy]

  def index
    @featureusages = Featureusage.all
  end

  def show
    @feature = Feature.find(params[:feature_id])
  end

  new
  def new
    @feature = Feature.find(params[:feature_id])
    @featureusage = @feature.featureusages.build
  end

  def edit; end

  def create
    @feature = Feature.find(params[:feature_id])
    @featureusage = @feature.featureusages.new(featureusage_params)
    @featureusage.buyer_id = current_user.id

    max_unit = Feature.find_by(id: params[:feature_id].to_s).max_unit_limit
    flash[:alert] = 'You are now using the extra units' if @featureusage.total_extra_units > max_unit
    respond_to do |format|
      if @featureusage.save
        format.html { redirect_to feature_featureusage_path(@feature, @featureusage) }
        format.json { render :show, status: :created, location: @featureusage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @featureusage.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @featureusage.update(featureusage_params)
        format.html do
          redirect_to feature_featureusage_url(@featureusage), notice: 'Featureusage was successfully updated.'
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
