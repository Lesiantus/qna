require 'rails_helper'

feature 'User can edit his question', %q{
  In order to edit question
  As an authenticated user and author of the question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'login as author' do
    scenario 'edit question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      fill_in 'Question title', with: 'Test question'
      fill_in 'Question body', with: 'text text text'
      click_on 'Save'

      expect(page).to have_content 'Your question successfully updated!'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end
  end

  scenario 'Not author tries to edit question' do
    sign_in(not_author)
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end
