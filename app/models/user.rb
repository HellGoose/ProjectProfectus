class User < ActiveRecord::Base
	#Required fields:
	validates :name, :provider, :uid, 
	:oath_token, :oaut_token_expires_at, 
	:role , presence: true

	#Relations:
	has_many :projects

	#Authentication
	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end
end
