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
end
