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

  describe 'GET #create' do
    context 'when is successfully created' do
      before :each do
        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }
      end

      it 'renders the json representation of the user record created' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(@user_attributes[:email])
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before :each do
        invalid_user_attributes = { password: 'helloworld',
                                    password_confirmation: 'helloworld'
                                   }
        post :create, { user: invalid_user_attributes }
      end

      it 'renders an errors json' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'renders the json errors' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end

      it { respond_with 422 }
    end
  end
end
