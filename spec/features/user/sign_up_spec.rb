require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions, make answers,
  As a guest,
  I'd like to sign up.
} do

  given(:user) { create(:user) }

  describe 'User creates account, clicking sign_up' do

    background { visit new_user_registration_path }

    scenario 'user signs up' do
      fill_in 'Email', with: 'user@test.com'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(current_path).to eq root_path
    end
  end
end
