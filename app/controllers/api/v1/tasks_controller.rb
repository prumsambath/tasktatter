class Api::V1::TasksController < ApplicationController
  respond_to :json

  def create
    list = List.find(params[:list_id])
    list.tasks.build(task_params)
    list.save
    render json: list.tasks, status: 201
  end

  private

  def task_params
    params.require(:task).permit(:title)
  end
end
