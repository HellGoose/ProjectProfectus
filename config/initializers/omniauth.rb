OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '820192964704242', '9d70f7e60aa03921156b839b978e3a6b',
  {
  	:scope => 'email,public_profile',
  	:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}
  }
end