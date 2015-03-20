require 'rails_helper'

describe Api::V1::TasksController do
  context "for user's own list" do
    describe "POST #create" do
      context "when is successfully created" do
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
      end

      context "when is not created" do
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
      end
    end

    describe "PATCH #update" do
      context "when is successfully updated" do
        before :each do
          user = create(:user)
          list = create(:list, user: user)
          @task = create(:task, completed: false)

          task_attributes = { id: @task.id, task: { completed: true }, list_id: list.id }
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
  end

  context "for another user's list" do
    describe "POST #create" do
      it "creates a task in another user's list whose permission is open" do
        john = create(:user, email: 'john@example.com')
        jane = create(:user, email: 'jane@example.com')
        jane_list = create(:list, permission: :open, user: jane)

        task_attributes = { task: attributes_for(:task), list_id: jane_list.id }
        params = task_attributes.merge(auth_token: john.auth_token)

        expect {
          post :create, params
        }.to change(Task, :count).by(1)
      end

      it "does not create a task in another user' list whose permission is not open" do
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

    describe "PATCH #update" do
      it "updates the task to be complete if the list permission is open" do
        john = create(:user, email: 'john@example.com')

        jane = create(:user, email: 'jane@example.com')
        jane_list = create(:list, permission: :open, user: jane)
        jane_task = create(:task, completed: false, list: jane_list)

        task_attributes = { id: jane_task.id, task: { completed: true }, list_id: jane_task.list.id }
        params = task_attributes.merge(auth_token: john.auth_token)

        patch :update, params

        jane_task.reload

        expect(jane_task.completed).to eq(true)
      end

      it "does not update the task to be complete if the list permission is not open" do
        john = create(:user, email: 'john@example.com')

        jane = create(:user, email: 'jane@example.com')
        jane_list = create(:list, permission: :private, user: jane)
        jane_task = create(:task, completed: false, list: jane_list)

        task_attributes = { id: jane_task.id, task: { completed: true }, list_id: jane_task.list.id }
        params = task_attributes.merge(auth_token: john.auth_token)

        patch :update, params

        jane_task.reload

        expect(jane_task.completed).to eq(false)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
