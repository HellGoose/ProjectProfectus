class CampaignVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :campaign_id, presence: true
	
	#Relations (Used like: ClassName.relation):
	belongs_to :user
	belongs_to :campaign

	#Callbacks
	after_initialize :init
	after_create :update_campaign

	private
		def init
			self.step ||= 0 if self.has_attribute? :step
			self.voteType ||= 0 if self.has_attribute? :voteType
		end

		def update_campaign
			campaign = self.campaign
			campaign.lock!
			campaign.timesShownInVoting += 1
			if !campaign.save
				p campaign.errors
			end
		end
end
