class DailyDigestJob < ApplicationJob
  queue_as :mailer

  def perform
    DailyDigest.new.send_digest
  end
end
