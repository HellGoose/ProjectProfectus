class RoundWinnerCampaign < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	belongs_to :campaign
	belongs_to :round
end
