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
end
