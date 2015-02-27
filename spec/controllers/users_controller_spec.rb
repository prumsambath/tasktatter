require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    before :each do
      @user = create(:user)
      get :show, id: @user.id, format: :json
    end

    it 'returns the information of the user' do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eq(@user.email)
    end

    it { should respond_with 200 }
  end
end
