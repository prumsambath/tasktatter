require 'rails_helper'

describe Api::V1::ListsController do
  describe 'GET #index' do
    before :each do
      user = create(:user)
      @list1 = create(:list, user: user)
      @list2 = create(:list, user: user)

      get :index, { auth_token: user.auth_token }
    end

    it "returns the user's lists" do
      list_titles = json_response.map { |item| item[:title] }
      expect(list_titles).to match_array([@list1.title, @list2.title])
    end

    it { should respond_with :ok }
  end

  describe 'GET #show' do
    before :each do
      user = create(:user)
      list = create(:list, user: user)
      5.times { create(:task, list: list) }

      get :show, { id: list.id, auth_token: user.auth_token }
    end

    it 'returns all tasks in the current list' do
      task_count = json_response.length
      expect(task_count).to eq(5)
    end

    it { should respond_with :ok }
  end

  describe 'POST #create' do
    it 'adds a new list' do
      user = create(:user)
      list_attributes = { list: attributes_for(:list), user_id: user.id }
      params = list_attributes.merge(auth_token: user.auth_token)

      expect {
        post :create, params
      }.to change(List, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
      @list = create(:list, user: @user)
      3.times { create(:task, list: @list) }
    end

    it 'removes the list and its associated tasks' do
      expect {
        delete :destroy, { id: @list.id, auth_token: @user.auth_token }
      }.to change(List, :count).by(-1)
    end

    it 'removes all associated tasks' do
      delete :destroy,{ id: @list.id, auth_token: @user.auth_token }
      expect(Task.where("list_id = ?", @list.id)).to be_empty
    end

    it 'returns http status code :no_content' do
      delete :destroy, { id: @list.id, auth_token: @user.auth_token }
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'permission' do
    describe "change a list's permission" do
      before :each do
        @list = create(:list)
      end

      it 'changes the permission of the list when the permission is correct' do
        patch :update, { id: @list.id, list: { permission: :viewable }, auth_token: @list.user.auth_token }

        @list.reload
        expect(@list.permission.to_sym).to eq(:viewable)
      end

      it 'does not change the permission when the permission is not correct' do
        patch :update, { id: @list.id, list: { permission: :not_exist }, auth_token: @list.user.auth_token }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe 'view a list' do
      before :each do
        @john = create(:user)
        @jane = create(:user)
      end

      it "allows other user to view the list if its permission is viewable" do
        list = create(:list, permission: 'viewable', user: @john)

        get :show, { id: list, auth_token: @jane.auth_token }

        expect(json_response.length).to eq(list.tasks.count)

        expect(response).to have_http_status(:ok)
      end

      it "does not allow other user to view if its permissin is private" do
        list = create(:list, permission: :private, user: @john)

        get :show, { id: list, auth_token: @jane.auth_token }

        expect(json_response).to have_key(:errors)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
