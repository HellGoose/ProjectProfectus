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

	# Public: Renders a view containing information about refer-a-friend
	# Route: GET root/singup/:referer
	# 	:referer - The id of the refering user.
	#
	# Renders home#refer_a_friend in window-mode.
	def refer_a_friend
		respond_to do |format|
			format.html { render partial: 'refer_a_friend', layout: 'windowed' }
		end
	end
end
