require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:not_author) { create(:user) }

  scenario 'Unauthenticated uer cannot edit answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user ' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(answer.question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
      end
    end
    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
  describe 'Authenticated user cannot edit answer of another user' do
    scenario 'tries to edit other user answer', js: true do
      sign_in not_author
      visit question_path(answer.question)
      expect(page).to_not have_link 'Edit'
    end
  end
end
