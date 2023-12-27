require 'rails_helper'

feature 'Authorized user can unsubscribe from question', %q{
  In order to stop being informed about certain question
  As an authenticated user
  I'd like to be able to stop receiving notifications about new answers
  For question
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:subscription) { create :subscription, user: user, question: question }

  scenario 'authenticated user unsubscribes question', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Unsubscribe'
    expect(page).to_not have_content 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  scenario 'Unauthenticated user unsubscribes question', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
  end
end
