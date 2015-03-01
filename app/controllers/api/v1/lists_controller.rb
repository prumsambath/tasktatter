class Api::V1::ListsController < ApplicationController
  respond_to :json

  def index
    render json: current_user.lists, status: 200
  end

  def show
    list = List.find(params[:id])
    render json: list.tasks, status: 200
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    head 204
  end
end
