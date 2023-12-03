require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions, make answers,
  As a guest,
  I'd like to sign up.
} do

  given(:user) { create(:user) }

  background do
    visit root_path
    click_on 'Sign up'
  end

  scenario 'Unregistred user tries to register' do

    fill_in 'Email', with: 'user@mail.net'
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    sleep 1
    open_email('user@mail.net')
    current_email.click_link 'Confirm my account'


    fill_in 'Email', with: 'user@mail.net'
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'user@mail.net'
    expect(page).to have_content 'Sign out'
  end
end
