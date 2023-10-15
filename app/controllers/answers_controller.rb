class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new index create]
  before_action :find_answer, only: %i[edit update destroy]

  def index
    @answers = current_question_answers
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_answers_path(@question)
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer deleted sucessfully!'
    else
      redirect_to question_path(@answer.question), alert: "You can only delete your own answers!"
    end
  end

  private

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
    @answers = @question.answers
  end
end
