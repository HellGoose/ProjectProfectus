class User < ActiveRecord::Base
	#Required fields:
	validates :name, :provider, :uid, 
	:oauth_token, :oauth_token_expires_at, 
	:role, presence: true

	#Relations:
	has_many :projects
	has_many :posts
	has_many :topics
	has_many :projectDonations, class_name: "ProjectDonation"
	has_many :projectVotes, class_name: "ProjectVote"
	has_many :topicVotes, class_name: "TopicVote"
	has_many :postVotes, class_name: "PostVote"
	has_many :projectsVoted, class_name: "Project", through: "ProjectVote"
	has_many :topicsVoted, class_name: "Post", through: "TopicVote"
	has_many :postsVoted, class_name: "Post", through: "PostVote"
	has_many :projectDonated, class_name: "Project", through: "ProjectDonation"


	#Authentication
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.email = auth.info.email
			user.oauth_token = auth.credentials.token
			user.oauth_token_expires_at = Time.at(auth.credentials.expires_at)
			user.role = 0
			user.points = 0
			user.save!
		end
	end

	after_initialize :init
	def init
		self.subscriptionAmount ||= 0 if self.has_attribute? :donationAmount
		self.money ||= 0 if self.has_attribute? :money
	end
end
