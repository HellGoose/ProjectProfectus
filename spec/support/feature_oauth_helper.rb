module FeatureOauthHelper
  def login_with_oauth(service = :facebook, user)
  	#OmniAuth.config.mock_auth[service] = nil
  	OmniAuth.config.test_mode = true
  	# OmniAuth.config.add_mock(:default, {
  	OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
	    provider: 'facebook',
	    uid: user.uid,
	    info: {
	      name: 	user.name,
	      email: 	user.email
	    },
	    credentials: {
	      token: "123456",
	      expires_at: Time.now + 1.week
	    },
	  })
    visit "/auth/#{service}/callback"
  end
end