class Campaign < ActiveRecord::Base
	#Restrictions
	validates :link, :user_id, presence: true

	#Relations
	belongs_to :user
	belongs_to :category
	has_many :posts, :dependent => :destroy
	has_many :votes, class_name: "CampaignVote", :dependent => :delete_all
	has_many :usersVoted, class_name: "User", through: "campaign_votes"

	#Callbacks
	after_initialize :init
	
	private
		#Sets default values
		def init
			self.title ||= "" if self.has_attribute? :title
			self.description ||= "" if self.has_attribute? :description
			self.voteCount ||= 0 if self.has_attribute? :voteCount
		end
end