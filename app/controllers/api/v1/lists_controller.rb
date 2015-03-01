class Api::V1::ListsController < ApplicationController
  respond_to :json

  def index
    render json: current_user.lists, status: 200
  end
end
