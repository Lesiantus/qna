require 'rails_helper'

feature 'Best answer', %q{
  to choose the answer which is the best
  As an authenticated user
  I want to be able to set best answer to my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, question: question, user: user) }

  scenario 'Unauthenticated user or non question author can not set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose the best'
  end

  describe 'Authenticated user is question author', js: true do
    before { sign_in user }
    before { visit question_path(question) }

    scenario 'best answer link not available for best answer', js: true do
      within(".answer-#{answers[0].id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
      end

      within(".answer-#{answers[1].id}") do
        expect(page).to have_link 'Choose the best'
      end
    end

    scenario 'best answer is first in list', js: true do
      visit question_path(question)
      best_answer = answers[2]
      within(".answer-#{best_answer.id}") { click_on 'Choose the best' }

      within all('.answers').first do
        expect(page).to have_content best_answer.body
      end
    end
  end
end
