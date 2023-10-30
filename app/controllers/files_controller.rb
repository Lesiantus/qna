class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(@file.record)
      @file.purge
    else
      redirect_to @file.record
    end
  end
end
