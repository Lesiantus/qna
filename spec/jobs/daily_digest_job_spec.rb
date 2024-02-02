require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestJob') }

  before do
    allow(DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls DailyDigest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
