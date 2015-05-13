class HomeController < ApplicationController

	# Public: Prepares variables for home#index
	# Route: root
	#
	# @campaigns 	- The top 8 campaigns.
	# @allNews 	 	- All news present in the database.
	# @newsInterval - Number of news shown before the "Show More" button.
	#
	# Renders home#index.
	def index
		orderedCampaigns = Campaign.order("(roundScore + globalScore) DESC");
		@campaigns = orderedCampaigns.first(8)
		@allNews = News.order("created_at DESC")
		@newsInterval = 5
	end
end
