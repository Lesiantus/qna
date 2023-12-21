class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy best]
  before_action :find_question, only: %i[index create new]
  before_action :current_question_answers, only: %i[destroy best]
  after_action :publish_answer, only: [:create]

  include Voted
  include Commented

  authorize_resource

  def index
    @answers = current_question_answers
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        files_info = @answer.files_info.map do |file_info|
          file = ActiveStorage::Attachment.find(file_info[:id]).blob
          file_info.merge({ url: rails_blob_path(file, only_path: true) })
        end

        format.json { render json: @answer.as_json(
                      include: { links: { only: [:name, :url] } },
                      methods: [:files_info]
                      ).merge({ files_info: files_info })
                    }
      else
        format.json do
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    if autorship!
      if answer_params[:files].present?
        @answer.files.attach(answer_params[:files])
      end
      if @answer.update(answer_params.except(:files))
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

  def publish_answer
    return if @answer.errors.any?

    answer_info = @answer.as_json(include: :votes)
    answer_info[:rating] = @answer.rating
    answer_info[:vote_up_path] = polymorphic_path([@answer], action: :vote_up)
    answer_info[:vote_down_path] = polymorphic_path([@answer], action: :vote_down)

    ActionCable.server.broadcast(
      "questions/#{@question.id}",
      answer_info.to_json
    )
  end

  def autorship!
    current_user.author?(@answer)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def current_question_answers
    @answers = @answer.question.answers
  end
end
