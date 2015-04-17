class RoundWinnerCampaign < ActiveRecord::Base
	belongs_to :campaign
	belongs_to :round
end
