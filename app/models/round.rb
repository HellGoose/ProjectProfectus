class Round < ActiveRecord::Base
	#Relations (Used like: ClassName.relation):
	has_many :winnerUsers, class_name: "RoundWinnerUser"
	has_many :winnerCampaigns, class_name: "RoundWinnerCampaign"
end
