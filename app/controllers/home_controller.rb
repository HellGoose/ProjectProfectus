class HomeController < ApplicationController

	def index
		filteredCampaigns = Campaign.select("id, title, description, voteCount, image").where("").order("voteCount DESC");
		@campaigns = filteredCampaigns.first(8)
		@all_news = News.order("created_at DESC")
		@newsInterval = 5


		if current_user
			step = 0
			campaignVotes = current_user.campaignVotes.find_by(step: step)

			puts campaignVotes




			@campaignVoting = current_user.campaignsVoted
			if @campaignVoting == []
				@campaignVoting << Campaign.all.sample(9)
				current_user.save
			end
		end
	end
end
