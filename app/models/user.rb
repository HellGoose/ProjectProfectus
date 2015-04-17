class User < ActiveRecord::Base
	#Restrictions:
	validates :name, :provider, :uid, 
	:oauth_token, :oauth_token_expires_at, 
	:role, presence: true

	#Relations:
	has_many :posts
	has_many :campaigns
	has_many :badges, class_name: "UserBadge"
	has_many :postVotes, class_name: "PostVote"
	has_many :campaignVotes, class_name: "CampaignVote"
	has_many :postsVoted, class_name: "Post", through: "PostVote"
	has_many :campaignsVoted, class_name: "Campaign", :through => :campaignVotes, :source => :campaign


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

	#Callbacks
	after_initialize :init
	before_update :lvlUp, :achieveBadge

	private
		#Set default values
		def init
			self.username ||= "" if self.has_attribute? :username
			self.location ||= "" if self.has_attribute? :location
			self.image ||= "" if self.has_attribute? :image
			self.phone ||= "" if self.has_attribute? :phone
			self.points ||= 0 if self.has_attribute? :points
			self.level ||= 1 if self.has_attribute? :level
			self.role ||= 0 if self.has_attribute? :role
			self.badgeCount ||= 0 if self.has_attribute? :badgeCount
		end

		#Update level
		def lvlUp
			self.level = (self.points/1000).floor + 1
		end

		#Update badges
		def achieveBadge
			campaignCount = self.campaigns.count

			#One-timers (Only awardable once)
			#The first campaign
			if campaignCount == 1 and !self.badges.find_by(badge_id: 2)
				self.badges.create(user_id: self.id, badge_id: 2, timesAchieved: 1)
				self.points += Badge.find(2).points
			end
			#Multi-timers (Awardable multiple times)
			#Created 10 campaigns
			if campaignCount > 0 and campaignCount%10 == 0
				if !self.badges.find_by(badge_id: 3)
					self.badges.create(user_id: self.id, badge_id: 3, timesAchieved: 1)
					self.points += Badge.find(3).points
				elsif campaignCount/10 > self.badges.find_by(badge_id: 3).timesAchieved
					self.badges.find_by(badge_id: 3).timesAchieved = campaignCount/10
					self.points += Badge.find(3).points
				end
			end
		end
end