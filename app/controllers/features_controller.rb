# frozen_string_literal: true

# All feature operations
class FeaturesController < ApplicationController
  before_action :set_feature, only: %i[show edit update destroy]
  
  def index
    @feature = Feature.all
    # authorize @feature
    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @feature }
    end
  end

  def new
    @feature = Feature.new
    # authorize @feature
  end

  def create
    @feature = Feature.new(feature_params)
    # @feature.admin_id = current_user.id
    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, notice: 'Feature was successfully created.' }
        format.json { render json: @feature, status: :created }
      else
        format.html { render :new }
        format.json { render json: @feature.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    # authorize @feature
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
        format.json { render json: @feature, status: :created }
      else
        format.html { render :edit }
        format.json { render json: @featrue.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # authorize @feature
    if @feature.destroy
      render json: { json: 'feature was successfully deleted.' }
    else
      render json: { json: @featrue.errors, status: :unprocessable_entity }
    end
  end

  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: @feature }
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
