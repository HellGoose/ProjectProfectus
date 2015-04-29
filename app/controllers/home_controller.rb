class HomeController < ApplicationController
	def index
		filteredCampaigns = Campaign.order("(roundScore + globalScore) DESC");
		@campaigns = filteredCampaigns.first(8)
		@all_news = News.order("created_at DESC")
		@newsInterval = 5
		@campaignVoting = []
	end
end