require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    before :each do
      @user = create(:user)

      api_authorization_header @user.auth_token
      get :show, id: @user.id, format: :json
    end

    it 'returns the information of the user' do
      expect(json_response[:email]).to eq(@user.email)
    end

    it { should respond_with :ok }
  end

  describe 'GET #create' do
    context 'when is successfully created' do
      before :each do
        user = create(:user)
        api_authorization_header user.auth_token

        @user_attributes = attributes_for :user
        post :create, { user: @user_attributes }
      end

      it 'renders the json representation of the user record created' do
        expect(json_response[:email]).to eq(@user_attributes[:email])
      end

      it { should respond_with :created }
    end

    context 'when is not created' do
      before :each do
        user = create(:user)
        api_authorization_header user.auth_token

        invalid_user_attributes = { password: 'helloworld',
                                    password_confirmation: 'helloworld'
                                   }
        post :create, { user: invalid_user_attributes }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors' do
        expect(json_response[:errors][:email]).to include("can't be blank")
      end

      it { respond_with :unprocessable_entity }
    end
  end

  describe 'PATCH #update' do
    context 'when is successfully updated' do
      before :each do
        @user = create(:user)
        api_authorization_header @user.auth_token
        @new_email = 'newemail@example.com'
        patch :update, { id: @user.id, user: { email: @new_email } }
      end

      it 'renders the json representation of the updated user' do
        expect(json_response[:email]).to eq(@new_email)
      end

      it { should respond_with :ok }
    end

    context 'when is not updated' do
      before :each do
        @user = create(:user)
        api_authorization_header @user.auth_token
        patch :update, { id: @user.id, user: { email: 'bademail.com' } }
      end

      it 'renders an errors json' do
        expect(json_response).to have_key(:errors)
      end

      it 'renders the json errors' do
        expect(json_response[:errors][:email]).to include('is invalid')
      end

      it { respond_with :unprocessable_entity }
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      user = create(:user)
      api_authorization_header user.auth_token
      delete :destroy, { id: user.id }
    end

    it { should respond_with :no_content }
  end
end
