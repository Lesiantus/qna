class NewAnswerNotifierJob < ApplicationJob
  queue_as :mailer

  def perform(answer)
    service = NewAnswerNotifier.new(answer)
    service.send_notifier
  end
end
