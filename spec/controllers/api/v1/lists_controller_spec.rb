require 'rails_helper'

describe Api::V1::ListsController do
  describe 'GET #index' do
    before :each do
      user = create(:user)
      @list1 = create(:list, user: user)
      @list2 = create(:list, user: user)

      api_authorization_header user.auth_token
      get :index
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

      api_authorization_header user.auth_token
      get :show, id: list.id
    end

    it 'returns all tasks in the current list' do
      task_count = json_response.length
      expect(task_count).to eq(5)
    end

    it { should respond_with :ok }
  end

  describe 'DELETE #destroy' do
    before :each do
      user = create(:user)
      api_authorization_header user.auth_token
      @list = create(:list, user: user)
      3.times { create(:task, list: @list) }
    end

    it 'removes the list and its associated tasks' do
      expect {
        delete :destroy, id: @list.id
      }.to change(List, :count).by(-1)
    end

    it 'removes all associated tasks' do
      delete :destroy, id: @list.id
      expect(Task.where("list_id = ?", @list.id)).to be_empty
    end

    it 'returns http status code :no_content' do
      delete :destroy, id: @list.id
      expect(response).to have_http_status(:no_content)
    end
  end
end
