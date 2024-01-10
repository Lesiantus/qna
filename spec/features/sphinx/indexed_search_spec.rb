require 'sphinx_helper'

feature 'User can search answer, questions, comments, users', %q{
  As a guest or user,
  i'd like to be able to find questions, answers or comments
  with one remembered word
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, body: 'answer', user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  background { visit root_path }

  describe 'User searches one type:', sphinx: true, js: true do
    scenario 'Answer' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'answer'
        check 'answer'
        click_on 'Find'
        within '.search_results' do
          expect(page).to have_content 'answer'
        end
      end
    end

    scenario 'Question' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'MyString'
        check 'question'
        click_on 'Find'
        within '.search_results' do
          expect(page).to have_content '12t12'
        end
      end
    end

    scenario 'Comment' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'text text'
        check 'comment'
        click_on 'Find'
        within '.search_results' do
          expect(page).to have_content 'text text'
        end
      end
    end

    scenario 'User' do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test'
        check 'user'
        click_on 'Find'

        within '.search_results' do
          expect(page).to have_content(/@test\.com/)
        end
      end
    end
  end
end
