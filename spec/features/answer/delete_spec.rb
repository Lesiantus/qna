require 'rails_helper'

feature 'User can delete answer' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author can delete answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on '| Delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Not an author tries to delete answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Not authenticated user delete answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end
