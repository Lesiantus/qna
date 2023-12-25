class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create destroy]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    flash.now[:notice] = 'Subscription created'
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(question_id: @question.id)
    @subscription.destroy
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end
end
