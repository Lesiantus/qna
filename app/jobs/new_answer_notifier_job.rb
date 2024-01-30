class NewAnswerNotifierJob < ApplicationJob
  queue_as :mailer

  def perform(answer)
    service = Services::NewAnswerNotifier.new(answer)
    service.send_notifier
  end
end
