class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def author?(params)
    params.user_id == id
  end

  def self.find_for_oauth(auth)
    ExternalServices::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
