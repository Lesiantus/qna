class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth

  def github; end

  def vkontakte; end

  private

  def oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      if @user.email_confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      else
        redirect_to after_sign_up_unconfirmed_path(@user)
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
