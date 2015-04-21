module RequestOauthHelper
  def login_with_oauth(service = :facebook, user)
  	OmniAuth.config.test_mode = true
  	OmniAuth.config.add_mock(:default, {
	    provider: 'facebook',
	    uid: '123456',
	    info: {
	      name: 	user.name,
	      email: 	user.email
	    }, 
	    credentials: {
	      token: "654321",
	      expires_at: Time.now + 1.week
	    },
	  })
    get "/auth/#{service}/callback"
  end
end