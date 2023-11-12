require 'rails_helper'

feature 'User can use voting system', %q{
  In order to provide community with addional info
  As an authenticated user
  I'd like to use vote system to vote question
}do
  given(:user) { create :user }
  given(:other_user) { create :user }
  given!(:question) { create :question, user: other_user }
  given!(:question1) { create :question, user: user }

  describe 'User votes for question', js: true do
    context 'Authenticated user' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'votes up' do
        visit question_path(question)
        within(".question-#{question.id}") do
          find('.plus').click
          expect(find('.score')).to have_content '1'
        end
      end

      scenario 'votes down' do
        within(".question-#{question.id}") do
          find('.minus').click

          expect(find('.score')).to have_content '-1'
        end
      end

      scenario 'votes up only ones' do
        within(".question-#{question.id}") do
          find('.plus').click
          find('.plus').click

          expect(find('.score')).to have_content '1'
        end
      end

      scenario 'votes down only ones' do
        within(".question-#{question.id}") do
          find('.minus').click
          find('.minus').click

          expect(find('.score')).to have_content '-1'
        end
      end

      scenario 'votes for own question' do
        visit question_path(question1)
        within ".question-#{question1.id}" do
          expect(page).to_not have_css('.plus')
          expect(page).to_not have_css('.minus')
        end
      end
    end

    context 'Unauthenticated user' do
      background do
        visit question_path(question)
      end

      scenario 'votes up for question' do
        expect(page).to_not have_selector('.voting')
      end
    end
  end
end
