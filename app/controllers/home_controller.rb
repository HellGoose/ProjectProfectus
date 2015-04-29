class HomeController < ApplicationController
	def index
		filteredCampaigns = Campaign.order("(roundScore + globalScore) DESC");
		@campaigns = filteredCampaigns.first(8)
		@all_news = News.order("created_at DESC")
		@newsInterval = 5
		@campaignVoting = []

		if current_user and filteredCampaigns != []
			setUpCampaignVoting
		end
	end

	private
		def setUpCampaignVoting
			if current_user.campaignVotes == [] and current_user.isOnStep <= 4
				campaignVotes = genCampaignsForVoting
		
			elsif current_user.isOnStep >= 3
				campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
				@votedFor = current_user.campaignVotes.where(voteType: 2)
			
			else
				campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
			end

			for i in 0..2
				next if (campaignVotes[i] == nil)
				@campaignVoting << campaignVotes[i].campaign
			end
		end

		def genCampaignsForVoting
			current_user.isOnStep = 0
			campaignVotes = current_user.campaignVotes
			genedCampaigns = []

			campaigns = Campaign.order("(roundScore + globalScore) DESC")

			genedCampaigns << campaigns.last(campaigns.size * 0.5).sample(3)
			genedCampaigns << campaigns.slice((campaigns.size * 0.2)..(campaigns.size * 0.5)).sample(3)
			genedCampaigns << campaigns.first(campaigns.size * 0.2).sample(3)

			for i in 0..8
				step = (i / 3).to_i
				campaignVotes.create(user_id: current_user.id, campaign_id: genedCampaigns[step][i % 3].id, step: step)
			end

			current_user.save
			current_user.campaignVotes.where(step: current_user.isOnStep)
		end
end