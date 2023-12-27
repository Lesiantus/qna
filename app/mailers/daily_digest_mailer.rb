class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    now = Time.now
    @questions = Question.where(created_at: (now - 24.hours)..now)
    @user = user

    mail to: user.email,
         subject: 'Here are the list of question for the last 24 hours:'
  end
end
