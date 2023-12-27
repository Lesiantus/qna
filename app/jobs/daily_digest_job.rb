class DailyDigestJob < ApplicationJob
  queue_as :mailer

  def perform
    ExternalServices::DailyDigest.new.send_digest
  end
end
