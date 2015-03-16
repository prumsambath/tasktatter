module Authenticable
  def current_user
    @current_user ||= User.find_by(auth_token: params[:auth_token])
  end

  def authenticate_with_token!
    render json: { errors: 'Not authorized' },
      status: :unauthorized unless current_user.present?
  end
end
