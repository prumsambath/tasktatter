class Api::V1::TasksController < ApplicationController
  respond_to :json

  def create
    list = List.find(params[:list_id])
    list.tasks.build(task_params)
    list.save
    render json: list.tasks, status: 201
  end

  def update
    list = List.find(params[:list_id])
    task = Task.find(params[:id])
    if task.update_attributes(task_params)
      render json: list.tasks, status: 200
    else
      render json: task.errors, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
