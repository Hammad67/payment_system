class FeaturesController < ApplicationController
  def new
    @feature=Feature.new
  end

  def create
     
    @feature = Feature.new(feature_params)
    authorize @feature
    @feature.admin_id=current_user.id
    @feature.plan_id=params[:feature][:plan_id]

    respond_to do |format|
      if @feature.save
        format.html { redirect_to feature_url(@feature), notice: "feature was successfully created." }
        format.json { render :show, status: :created, location: @feature }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /features/1 or /features/1.json
  def update
    respond_to do |format|
      if @feature.update(feature_params)
        @feature.admin_id=current_user.id
        format.html { redirect_to feature_url(@feature), notice: "feature was successfully updated." }
        format.json { render :show, status: :ok, location: @feature }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1 or /features/1.json
  def destroy
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to features_url, notice: "feature was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = feature.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feature_params
      params.require(:feature).permit(:name, :code,:unit_price,:max_unit_limit)
    end
end
