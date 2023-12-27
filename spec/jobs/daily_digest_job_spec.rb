require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('ExternalServices::DailyDigestJob') }

  before do
    allow(ExternalServices::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls ExternalServices::DailyDigest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
