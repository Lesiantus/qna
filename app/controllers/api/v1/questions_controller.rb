module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource
      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: question
      end

      def create
        question = Question.new(question_params)
        question.user = current_resource_owner

        if question.save
          render json: question, status: :created
        else
          render json: question.errors, status: :unprocessable_entity
        end
      end

      def update
        question
        if question.update(question_params)
          render json: question, status: :ok
        else
          render json: question.errors, status: :unprocessable_entity
        end
      end

      def destroy
        question
        question.destroy
        render json: nil, status: :no_content
      end

      private

      def question
        @question ||= Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
