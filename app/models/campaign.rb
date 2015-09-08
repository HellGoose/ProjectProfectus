class Campaign < ActiveRecord::Base
	#Restrictions
	validates :link, :user_id, presence: true
	validates_uniqueness_of :title

	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :nominator, class_name: "User"
	belongs_to :category
	has_many :posts, :dependent => :destroy
	has_many :votes, class_name: "CampaignVote", :dependent => :delete_all
	has_many :usersVoted, class_name: "User", through: "campaign_votes"
	has_many :roundsWon, class_name: "RoundWinnerCampaign", :dependent => :delete_all

	#Callbacks
	after_initialize :init

	private
	#Sets default values
	def init
		self.image ||= "" if self.has_attribute? :image
		self.title ||= "" if self.has_attribute? :title
		self.description ||= "" if self.has_attribute? :description
		self.voteCount ||= 0 if self.has_attribute? :voteCount
		self.roundScore ||= 0 if self.has_attribute? :roundScore
		self.globalScore ||= 0 if self.has_attribute? :globalScore
		self.timesShownInVoting ||= 0 if self.has_attribute? :timesShownInVoting
		self.nominated = true if self.has_attribute? :nominated && self.nominated.nil?
		self.votable = false if self.has_attribute? :votable && self.votable.nil?
	end
end