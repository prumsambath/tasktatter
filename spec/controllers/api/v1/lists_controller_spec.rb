require 'rails_helper'

describe Api::V1::ListsController do
  describe 'GET #index' do
    before :each do
      user = create(:user)
      @list1 = create(:list)
      @list2 = create(:list)

      get :index
    end

    it "returns the user's lists" do
      p json_response
      list_titles = json_response.map { |item| item[:title] }
      p list_titles
      expect(list_titles).to match_array([@list1.title, @list2.title])
    end

    it { should respond_with 200 }
  end
end
