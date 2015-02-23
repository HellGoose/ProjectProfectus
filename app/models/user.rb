class User < ActiveRecord::Base
	#Required fields:
	validates :name, :provider, :uid, 
	:oauth_token, :oauth_token_expires_at, 
	:role , presence: true

	#Relations:
	has_many :projects
	has_and_belongs_to_many :project_votes, class_name: "Project"
	has_and_belongs_to_many :project_reviews, class_name: "Project"

	#Authentication
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.oauth_token = auth.credentials.token
			user.oauth_token_expires_at = Time.at(auth.credentials.expires_at)
			user.role = 0
			user.points = 0
			user.save!
		end
	end
end
