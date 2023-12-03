module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        'provider' => 'github',
        'uid' => '1235456',
        'info' => {
            'email' => 'test@test.test'
        }
      )

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        'provider' => 'vkontakte',
        'uid' => '1235456',
        'info' => {
            'email' => 'test@test.test'
        }
      )
  end
end
