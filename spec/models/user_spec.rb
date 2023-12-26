require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('ExternalServices::FindForOauth') }
    it 'calls for ExternalServices::FindForOauth' do
      expect(ExternalServices::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
  describe '#email_verified?' do
    let(:user_invalid) { create(:user, email: 'temp@temp.temp') }
    let(:user_valid) { create(:user, email: 'confirmed@mail.com') }

    it 'temporary email' do
      expect(user_invalid.email_confirmed?).to be_falsey
    end

    it 'confirmed email' do
      expect(user_valid.email_confirmed?).to be_truthy
    end
  end
end
