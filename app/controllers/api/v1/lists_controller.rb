class Api::V1::ListsController < ApplicationController
  include Authenticable

  before_action :authenticate_with_token!
  respond_to :json

  def index
    render json: current_user.lists, status: :ok
  end

  def show
    list = List.find(params[:id])
    if list.can_be_viewed_by?(current_user)
      render json: list.tasks, status: :ok
    else
      render json: { errors: 'Resource not found' }, status: :not_found
    end
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    head :no_content
  end

  def update
    list = current_user.lists.find(params[:id])
    if list.update(list_params)
      render json: list, status: :ok
    else
      render json: list.errors, status: :unprocessable_entity
    end
  end

  private

  def list_params
    params.require(:list).permit(:permission)
  end
end
