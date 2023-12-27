module ExternalServices
  class DailyDigest
    def send_digest
      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.digest(user).deliver_now
      end
    end
  end
end
