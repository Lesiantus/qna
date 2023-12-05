require 'rails_helper'

feature 'User can sign in via social networks', %q{
  In order to get lazy access to resource
  As an unauthenticated user
  I'd like to be able to sing in via social networks
} do

  context ' Sign up' do
    before { visit new_user_registration_path }

    scenario 'with Github' do
      mock_auth_hash
      click_on "Sign in with GitHub"

      expect(page).to have_content'Successfully authenticated from Github account.'
      expect(page).to have_content'Sign out'
    end

    scenario 'with vkontakte' do
      click_on "Sign in with Vkontakte"

      expect(page).to have_content'Successfully authenticated from Vkontakte account'
      expect(page).to have_content'Sign out'
    end
  end

  context 'Sign in' do
    let!(:user) { create(:user, email: 'mail@mail.net') }

    before { visit new_user_session_path }

    scenario 'GitHub' do
      click_on "Sign in with GitHub"
      page.refresh

      expect(page).to have_content'Successfully authenticated from Github account.'
      expect(page).to have_content'Sign out'
    end

    scenario 'vkontakte' do
      click_on "Sign in with Vkontakte"
      expect(page).to have_content'Successfully authenticated from Vkontakte'
    end
  end
end
