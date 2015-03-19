require 'rails_helper'

describe Api::V1::TasksController do
  context 'when is successfully created' do
    describe 'POST #create' do
      it 'saves the new task to the database' do
        user = create(:user)
        list = create(:list, user: user)
        task_attributes = { "task" => attributes_for(:task), "list_id" => list.id }
        params = task_attributes.merge(auth_token: user.auth_token)

        expect {
          post :create, params
        }.to change(Task, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it 'another user can create a task of a list whose permission is open' do
        john = create(:user, email: 'john@example.com')
        jane = create(:user, email: 'jane@example.com')
        jane_list = create(:list, permission: :open, user: jane)

        task_attributes = { task: attributes_for(:task), list_id: jane_list.id }
        params = task_attributes.merge(auth_token: john.auth_token)

        expect {
          post :create, params
        }.to change(Task, :count).by(1)
      end
    end
  end

  context 'when is not created' do
    describe 'POST #created' do
      before :each do
        user = create(:user)
        task_attributes = { task: { title: '' }, list_id: create(:list, user: user) }
        params = task_attributes.merge(auth_token: user.auth_token)

        post :create, params
      end

      it 'renders an errors json' do
        expect(json_response[:title]).to include("can't be blank")
      end

      it { should respond_with :unprocessable_entity }

      it 'another user cannot create a task of a list whose permission is not open' do
        john = create(:user, email: 'john@example.com')
        jane = create(:user, email: 'jane@example.com')
        jane_list = create(:list, permission: :private, user: jane)

        task_attributes = { task: attributes_for(:task), list_id: jane_list.id }
        params = task_attributes.merge(auth_token: john.auth_token)

        expect {
          post :create, params
        }.to change(Task, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      user = create(:user)
      @task = create(:task, completed: false)

      task_attributes = { id: @task.id, task: { completed: true }, list_id: @task.list.id }
      params = task_attributes.merge(auth_token: user.auth_token)

      patch :update, params

      @task.reload
    end

    it 'changes the task to be complete' do
      expect(@task.completed).to eq(true)
    end

    it { should respond_with :ok }
  end
end
