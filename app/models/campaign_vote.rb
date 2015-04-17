class CampaignVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :campaign_id, presence: true
	
	#Relations
	belongs_to :user
	belongs_to :campaign

	#Callbacks
	after_initialize :init

	private
		def init
			self.step ||= 0 if self.has_attribute? :step
			self.voteType ||= 0 if self.has_attribute? :voteType
		end
end
