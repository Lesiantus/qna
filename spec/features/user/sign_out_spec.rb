require 'rails_helper'

feature 'User can sign out', %q{
  As an athenticated user
  I'd like to be able to sign out.
} do

  given!(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'user signs out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
