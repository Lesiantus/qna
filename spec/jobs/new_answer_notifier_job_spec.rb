require 'rails_helper'

RSpec.describe NewAnswerNotifierJob, type: :job do
  let(:service) { double('NewAnswerNotifier') }
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question, user: user }

  before do
    allow(NewAnswerNotifier).to receive(:new).with(answer).and_return(service)
  end

  it 'calls NewAnswerNotifier' do
    expect(service).to receive(:send_notifier)
    NewAnswerNotifierJob.perform_now(answer)
  end
end
