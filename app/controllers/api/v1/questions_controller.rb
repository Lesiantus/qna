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

      private

      def question
        @question ||= Question.find(params[:id])
      end
    end
  end
end
