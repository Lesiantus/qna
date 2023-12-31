module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource
      def index
        render json: answers, each_serializer: AnswersSerializer
      end

      def show
        render json: answer
      end

      def create
        answer = question.answers.build(answer_params)
        answer.user = current_resource_owner

        if answer.save
          render json: answer, status: :created
        else
          render json: answer.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, answer
        answer

        if answer.update(answer_params)
          render json: answer, status: :ok
        else
          render json: answer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, answer
        answer

        answer.destroy
        render json: nil, status: :no_content
      end

      private

      def answers
        @answers ||= question.answers.all
      end

      def answer
        @answer ||= Answer.find(params[:id])
      end

      def question
        @question ||= Question.find(params[:question_id])
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
