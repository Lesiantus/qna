require 'rails_helper'

RSpec.describe NewAnswerNotifierJob, type: :job do
  let(:service) { double('ExternalServices::NewAnswerNotifier') }
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question, user: user }

  before do
    allow(ExternalServices::NewAnswerNotifier).to receive(:new).with(answer).and_return(service)
  end

  it 'calls ExternalServices::NewAnswerNotifier' do
    expect(service).to receive(:send_notifier)
    NewAnswerNotifierJob.perform_now(answer)
  end
end
