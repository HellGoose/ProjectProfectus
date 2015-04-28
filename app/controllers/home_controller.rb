class HomeController < ApplicationController
	def index
		filteredCampaigns = Campaign.where("").order("(roundScore + globalScore) DESC");
		@campaigns = filteredCampaigns.first(8)
		@all_news = News.order("created_at DESC")
		@newsInterval = 5

		if current_user
			campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)

			@campaignVoting = []
			if current_user.campaignVotes == [] and current_user.isOnStep <= 4
				current_user.isOnStep = 0

				campaigns = Campaign.order("(roundScore + globalScore) DESC")

				@campaignVoting << campaigns.last(campaigns.size * 0.5).sample(3)
				@campaignVoting << campaigns.slice((campaigns.size * 0.2)..(campaigns.size * 0.5)).sample(3)
				@campaignVoting << campaigns.first(campaigns.size * 0.2).sample(3)

				for i in 0..8
					step = (i / 3).to_i
					campaignVotes.create(user_id: current_user.id, campaign_id: @campaignVoting[step][i % 3].id, step: step)
				end
				campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
			
				current_user.save
			end
		
			if current_user.isOnStep >= 3
				campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
				@votedFor = current_user.campaignVotes.where(voteType: 2)
			end

			@campaignVoting = []
			for i in 0..2
				next if (campaignVotes[i] == nil)
				@campaignVoting << campaignVotes[i].campaign
			end			
		end
	end
end
