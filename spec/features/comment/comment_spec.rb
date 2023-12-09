require 'rails_helper'

feature 'User can comment resource', %q{
  In order to leave a comment
  As an authenticated user
  I'd like to have ability leave comments
} do
  given(:user) { create :user }
  given!(:question) { create :question, user: user }

  describe 'Not authenticated user' do
    scenario 'Can not comment' do
      visit question_path(question)

      expect(page).to_not have_selector '.comment-form'
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'can create a comment', js: true do
      fill_in 'body', with: 'text text'
      click_on 'Save comment'

      expect(page).to have_content 'text text'
    end
  end

  describe 'multiple sessions', js: true do
    scenario 'comments appears on another users page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'body', with: 'text text'
        click_on 'Save comment'

        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text'
      end
    end
  end
end
