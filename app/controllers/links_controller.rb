class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])

    if current_user&.author?(@link.linkable)
      @link.destroy
      flash[:notice] = 'Link was successfully deleted'
    else
      flash[:alert] = 'You are not an author!'
    end
  end
end
