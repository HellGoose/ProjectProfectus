class Campaign < ActiveRecord::Base
	#Restrictions
	validates :link, :user_id, :nominator_id, :crowdfunding_site_id, presence: true
	validates_uniqueness_of :link

	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :nominator, class_name: "User"
	belongs_to :category
	belongs_to :crowdfunding_site
	has_many :stars, class_name: "StaredCampaign"
	has_many :staredBy, class_name: "User", through: "stars", source: "user"
	has_many :reports, class_name: "ReportedCampaign", :dependent => :delete_all
	has_many :reportedBy, class_name: "User", through: "reports", source: "user"
	has_many :posts, :dependent => :destroy
	has_many :votes, class_name: "CampaignVote", :dependent => :delete_all
	has_many :usersVoted, class_name: "User", through: "votes", source: "user"
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
		self.status ||= "ready" if self.has_attribute? :status
		self.reported ||= 0 if self.has_attribute? :reported
	end
end