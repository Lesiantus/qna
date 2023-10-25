class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy best]
  before_action :find_question, only: %i[index create new]
  before_action :current_question_answers, only: %i[destroy best]

  def index
    @answers = current_question_answers
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if autorship!
      if @answer.update(answer_params)
        redirect_to @answer.question, notice: 'Answer successfully updated!'
      end
    else
      redirect_to @answer.question, notice: 'You are not an author!'
    end
  end

  def destroy
    if autorship!
      @answer.destroy
    else
      redirect_to question_path(@answer.question), alert: "You can only delete your own answers!"
    end
  end

  def best
    @answer.best! if current_user.author?(@answer.question)
  end

  private

  def autorship!
    current_user.author?(@answer)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def current_question_answers
    @answers = @answer.question.answers
  end
end
