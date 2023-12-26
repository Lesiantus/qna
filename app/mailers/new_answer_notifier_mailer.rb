class NewAnswerNotifierMailer < ApplicationMailer
  def new_answer_notifier(user, answer)
    @answer = answer
    @question = answer.question
    @user = user
    mail to: user.email,
         subject: "New answer for #{@question.title}"
  end
end
