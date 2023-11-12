module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_object, only: %i[vote_up vote_down]
  end

  def vote_up
    make_vote(:vote_up) unless current_user.author?(@object)
  end

  def vote_down
    make_vote(:vote_down) unless current_user.author?(@object)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_object
    @object = model_klass.find(params[:id])
  end

  def make_vote(vote_method)
    @object.send(vote_method, current_user)

    render json: { resourceName: @object.class.name.downcase,
                   resourceId: @object.id,
                   resourceScore: @object.rating }
  end
end
