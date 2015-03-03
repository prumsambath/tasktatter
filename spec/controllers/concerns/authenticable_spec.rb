require 'rails_helper'

class Authentication
  include Authenticable

  def request

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
end
