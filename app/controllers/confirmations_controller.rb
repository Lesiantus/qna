class ConfirmationsController < Devise::ConfirmationsController
  def after_sign_up_unconfirmed
    if user.email_confirmed?
      redirect_to root_path
    end
    if request_is_patch?
      if user.update(user_params)
        flash[:notice] = 'A confirmation email has been sent to your email address'
      end
    end
  end

  def user_params
    params.require(:user).permit(:email)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def request_is_patch?
    request.patch? && params[:user]
  end
end
