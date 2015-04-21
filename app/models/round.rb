class Round < ActiveRecord::Base
	has_many :winnerUsers, class_name: "RoundWinnerUser"
	has_many :winnerCampaigns, class_name: "RoundWinnerCampaign"
end
