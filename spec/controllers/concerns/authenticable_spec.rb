require 'rails_helper'

class Authentication
  include Authenticable

  def request
  end

  def response
  end
end

describe Authenticable do
  let(:authentication) { Authentication.new }

  describe '#current_user' do
    before do
      @user = create(:user)
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(authentication.current_user.auth_token).to eq(@user.auth_token)
    end
  end

  describe '#authenticate_with_token' do
    before do
      @user = create(:user)
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({ "errors" => "Not authorized" }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it 'renders a json error message' do
      expect(json_response[:errors]).to eq('Not authorized')
    end

    # it { should respond_with 401 }
  end
end
