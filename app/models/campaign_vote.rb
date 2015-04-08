class CampaignVote < ActiveRecord::Base
	#Restrictions
	validates :user_id, :campaign_id, presence: true
	
	#Relations
	belongs_to :user
	belongs_to :campaign
end
