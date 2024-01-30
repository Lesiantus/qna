require 'rails_helper'

RSpec.describe Services::NewAnswerNotifier do
  let(:user) { create :user}
  let(:user2) { create :user }
  let!(:question) { create :question }
  let!(:answer) { create :answer, question: question, user: user }
  let!(:subscription) { create(:subscription, question: question, user: user) }
  let!(:subscription2) { create(:subscription, question: question, user: user2) }
  subject { Services::NewAnswerNotifier.new(answer) }

  it 'sends email to subscribers' do
    users = [user, user2]
    users.each { |user| expect(NewAnswerNotifierMailer).to receive(:new_answer_notifier).with(user, answer).and_call_original }

    subject.send_notifier
  end
end
