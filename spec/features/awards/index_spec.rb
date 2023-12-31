require 'rails_helper'

feature 'User can look at his awards' do
  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:award) { create :award, :with_image, question: question }
  given!(:answer) { create :answer, question: question, user: user }

  it 'renders awards page', js: true do
    sign_in(user)
    # page.evaluate_script('location.reload')
    visit question_path(question)

    click_on 'Choose the best'
    visit awards_path

    expect(page).to have_content question.title
    expect(page).to have_content award.name
    expect(page).to have_selector 'img'
  end
end
