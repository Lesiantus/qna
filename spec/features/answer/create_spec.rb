require 'rails_helper'


feature 'User can create answer', %q{
  Authenticated user can write the answer to the question
  directly from the question page
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer the question', js: true do
      fill_in 'Body', with: 'answer body'

      click_on 'Answer'
      expect(page).to have_content 'answer body'
    end

    scenario 'answer the question with error', js: true do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answer the question with attached file', js: true do
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "answer appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'test answer'
      click_on 'Answer'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'test answer'
    end
  end

  scenario 'Not authenticated user answer a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Answer'
  end
end
