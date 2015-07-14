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


	# Public: Renders a partial view containing a notification.
	# Route: GET root/notifications
	#
	# unreadNotifications	- The PointsHistory of the user where they are not seen and sorted by oldest first.
	#
	# Renders home#notifications in a notification div on the front-end.
	# Renders nothing if user is not logged in or the user has no unseen notifications.
	def notifications
		if !current_user
			respond_to do |format|
				format.html { render nothing: true }
			end
			return
		end
		unreadNotifications = current_user.pointsHistories.where(seen: false).order('created_at ASC')

		if (unreadNotifications != [])
			@notification = unreadNotifications.first
			@notification.seen = true
			@notification.save
			respond_to do |format|
				format.html { render partial: 'notifications' }
			end
		else
			respond_to do |format|
				format.html { render nothing: true }
			end
		end
	end
end
