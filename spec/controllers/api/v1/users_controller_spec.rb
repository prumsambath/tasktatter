require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #show' do
    before :each do
      @user = create(:user)

      get :show, { id: @user.id, auth_token: @user.auth_token }, format: :json
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
        @new_email = 'newemail@example.com'

        patch :update, { id: @user.id, user: { email: @new_email }, auth_token: @user.auth_token }
      end

      it 'renders the json representation of the updated user' do
        expect(json_response[:email]).to eq(@new_email)
      end

      it { should respond_with :ok }
    end

    context 'when is not updated' do
      before :each do
        @user = create(:user)

        patch :update, { id: @user.id, user: { email: 'bademail.com' }, auth_token: @user.auth_token }
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
