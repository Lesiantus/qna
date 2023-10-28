require 'rails_helper'

feature 'Author of answer can delete attached file', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to delete attached file
} do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer,
                           question: question,
                           user: user,
                           files: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb")]) }

  scenario 'Author can delete attached file', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_link 'rails_helper.rb'

    click_on 'Edit'

    click_on 'Remove file'

    visit question_path(question)

    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Other user can not delete attached file' do
    sign_in other_user
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario 'Unauthenticated user can not delete attached file' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
