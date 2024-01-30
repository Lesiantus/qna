class DailyDigestJob < ApplicationJob
  queue_as :mailer

  def perform
    Services::DailyDigest.new.send_digest
  end
end
