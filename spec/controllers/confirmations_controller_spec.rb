require 'rails_helper'

RSpec.describe ConfirmationsController, type: :controller do
  let(:user) { create(:user, email: 'test@test.test') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe 'GET #after_signup' do
    context 'user proceed registration' do
      it 'confirms new email' do
        patch :after_sign_up_unconfirmed, params: { id: user, user: { email: 'new@mail.ru' } }
        sleep 1
        user.reload
        user.confirm

        expect(user.email).to eq 'new@mail.ru'
      end
    end

    context 'user exists' do
      let(:user) { create(:user) }
      it 'redirect to root_path' do
        login(user)
        get :after_sign_up_unconfirmed, params: { id: user }

        expect(response).to redirect_to root_path
      end
    end
  end
end
