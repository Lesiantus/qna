module ExternalServices
  class FindForOauth
    attr_reader :auth

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email] || temp_email
      user = User.where(email: email).first
      unless user
        user = User.new(email: email, password: create_password, password_confirmation: create_password)
        user.skip_confirmation!
        user.save!
      end

      user.create_authorization(auth)

      user
    end

    def temp_email
      "#{Devise.friendly_token[0, 20]}@temp.temp"
    end

    def create_password
      @password ||= Devise.friendly_token[0, 20]
    end
  end
end
