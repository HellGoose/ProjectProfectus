module FeatureOauthHelper
  def login_with_oauth(service = :facebook, user)
  	OmniAuth.config.test_mode = true
  	OmniAuth.config.add_mock(:default, {
	    provider: 'facebook',
	    uid: '123545',
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