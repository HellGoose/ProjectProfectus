class Round < ActiveRecord::Base
	has_many :winnerUsers, class: "RoundWinnerUser"
	has_many :winnerCampaigns, class: "RoundWinnerCampaign"
end
