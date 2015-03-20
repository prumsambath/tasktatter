class Api::V1::TasksController < ApplicationController
  include Authenticable

  before_action :authenticate_with_token!
  before_action :set_list, only: [:create, :update]
  respond_to :json

  def create
    task = @list.tasks.build(task_params)

    if @list.editable?(current_user) && @list.save
      render json: @list.tasks, status: :created
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  def update
    task = Task.find(params[:id])

    if @list.editable?(current_user) && task.update_attributes(task_params)
      render json: @list.tasks, status: :ok
    else
      render json: task.errors, status: :unprocessable_entity
    end
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
