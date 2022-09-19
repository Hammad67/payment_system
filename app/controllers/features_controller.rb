# frozen_string_literal: true

# All feature operations
class FeaturesController < ApplicationController
  before_action :set_feature, only: %i[show edit update destroy]
  
  def index
    @feature = Feature.all
    # authorize @feature
    render json: @feature
  end

  def new
    @feature = Feature.new
    # authorize @feature
  end

  def create
    @feature = Feature.new(feature_params)
    # @feature.admin_id = current_user.id
    if @feature.save
      render json: @feature, status: :created
    else
      render json: @feature.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    # authorize @feature
    if @feature.update(feature_params)
      render json: @feature, status: :created
    else
      render json: @featrue.errors.full_messages, status: :unprocessable_entity
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
    render json: @feature
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(:name, :code, :unit_price, :max_unit_limit)
  end
end
