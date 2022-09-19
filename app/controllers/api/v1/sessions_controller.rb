# frozen string literal:true
# Api::V1::SessionsController
class Api::V1::SessionsController < Devise::SessionsController
 
  prepend_before_action :require_no_authentication, only: :cancel
  respond_to :json

  private

  def respond_with(_resource, _opts = {})
    if current_user
      render json:
      { message: 'You are logged in.',
        user_type: current_user.type, jwt_tokken: current_token }, status: :ok
    else
      render json:
      { message: 'You are not logged in invalid credentials.' }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
  end

  def current_token
    request.env['warden-jwt_auth.token']
  end
end
