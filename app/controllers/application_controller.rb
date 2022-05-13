class ApplicationController < ActionController::Base
   before_action :authenticate_user!
   #  before_action :configure_permitted_parameters, if: :devise_controller?
   #  protected
   #     def configure_permitted_parameters
      
   #        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name,:type,:email, :password, :avatar)}
   #        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name,:type,:avatar, :email, :password, :current_password)}
        
   #     
   include Pundit
   rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
 end