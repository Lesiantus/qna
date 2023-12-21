class ApplicationController < ActionController::Base
  check_authorization unless: :do_not_check_authorization?
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|

    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end

  private

  def do_not_check_authorization?
    respond_to?(:devise_controller?)
  end

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
