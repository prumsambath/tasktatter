require 'rails_helper'

describe Api::V1::ListsController do
  describe 'GET #index' do
    before :each do
      user = create(:user)
      sign_in user

      @list1 = create(:list, user: user)
      @list2 = create(:list, user: user)

      get :index
    end

    it "returns the user's lists" do
      list_titles = json_response.map { |item| item[:title] }
      expect(list_titles).to match_array([@list1.title, @list2.title])
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before :each do
      user = create(:user)
      list = create(:list, user: user)
      5.times { create(:task, list: list) }

      get :show, id: list.id
    end

    it 'returns all tasks in the current list' do
      task_count = json_response.length
      expect(task_count).to eq(5)
    end

    it { should respond_with 200 }
  end
end
