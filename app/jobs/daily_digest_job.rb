class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    ExternalServices::DailyDigest.new.send_digest
  end
end
