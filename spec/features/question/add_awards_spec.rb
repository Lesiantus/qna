require 'rails_helper'

feature 'User can add award to question', %q{
  As an question's author
  I'd like to be able to add awards to it
} do

  given(:user) { create :user }

  scenario 'add award' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Award name', with: 'Award name'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(user.questions.last.award).to be_a(Award)
  end
end
