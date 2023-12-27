class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: %i[create]
  before_action :find_subscription, only: %i[destroy]

  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    flash.now[:notice] = 'Subscription created'
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(question_id: @find_subscription.question_id)
    @subscription.destroy
    flash.now[:notice] = 'Subscription deleted'
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def find_subscription
    @find_subscription ||= Subscription.find_by(question_id: params[:id])
    @question = Question.find(params[:id])
  end
end
