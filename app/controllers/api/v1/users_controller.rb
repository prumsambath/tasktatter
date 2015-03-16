class Api::V1::UsersController < ApplicationController
  include Authenticable

  before_action :authenticate_with_token!
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
