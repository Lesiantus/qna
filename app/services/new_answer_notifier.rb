class NewAnswerNotifier
  def initialize(answer)
    @answer = answer
  end

  def send_notifier
    @answer.question.subscriptions.find_each(batch_size: 500) do |subscriber|
      NewAnswerNotifierMailer.new_answer_notifier(subscriber.user, @answer).deliver_now
    end
  end
end
