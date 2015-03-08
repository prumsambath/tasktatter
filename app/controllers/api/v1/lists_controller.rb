class Api::V1::ListsController < ApplicationController
  include Authenticable

  before_action :authenticate_with_token!
  respond_to :json

  def index
    render json: current_user.lists, status: :ok
  end

  def show
    list = List.find(params[:id])
    render json: list.tasks, status: :ok
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    head :no_content
  end
end
