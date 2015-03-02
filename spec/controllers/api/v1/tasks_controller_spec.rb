require 'rails_helper'

describe Api::V1::TasksController do
  describe 'GET #create' do
    it 'saves the new task to the database' do
      list = create(:list)
      task_attributes = { "task" => attributes_for(:task), "list_id" => list.id }

      expect {
        post :create, task_attributes
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(201)
    end
  end

  describe 'PATCH #update' do
    before :each do
      @task = create(:task, completed: false)

      patch :update, { id: @task.id, task: { completed: true }, list_id: @task.list.id }

      @task.reload
    end

    it 'changes the task to be complete' do
      expect(@task.completed).to eq(true)
    end

    it { should respond_with 200 }
  end
end
