require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = create(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }
  it { should be_valid }

  it { should validate_uniqueness_of :auth_token }

  describe '#generate_auth_token' do
    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      @user.generate_auth_token!
      expect(@user.auth_token).to eq('auniquetoken123')
    end

    it 'generates another token when one has already been taken' do
      existing_user = create(:user, auth_token: 'auniquetoken123')
      @user.generate_auth_token!
      expect(@user.auth_token).to_not eq(existing_user.auth_token)
    end
  end
end
