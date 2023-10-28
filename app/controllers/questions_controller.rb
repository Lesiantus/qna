class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  def index
    @questions = Question.all
  end

  def show
    find_answers
    @answer = Answer.new
  end

  def new
    @question = current_user.questions.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if autorship!
      if question_params[:files].present?
        @question.files.attach(question_params[:files])
      end
      if @question.update(question_params.except(:files))
        redirect_to @question, notice: 'Your question successfully updated!'
      end
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your questions successfully deleted.'
    else
      redirect_to @question, notice: 'Only author can delete question.'
    end
  end

  private

  def autorship!
    current_user.author?(@question)
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def find_answers
    @answers = @question.answers
  end
end
