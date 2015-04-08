class HomeController < ApplicationController

	def index
		filteredCampaigns = Campaign.select("id, title, description, voteCount, image").where("").order("voteCount DESC");
		@campaigns = filteredCampaigns.first(8);
		@all_news = News.order("created_at DESC")
		@newsInterval = 5
	end
end
