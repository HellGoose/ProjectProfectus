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
		orderedCampaigns = Campaign.order("created_at DESC");
		@campaigns = orderedCampaigns.first(8)
		@allNews = News.order("created_at DESC")
		@newsInterval = 5
		redirect_to :controller => 'home', :action => 'landing' and return if current_user.nil?
	end

	def landing
		# render :layout => false
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

	def notifications
		if !current_user
			respond_to do |format|
				format.html { render json: { 'User' => 'not logged in' } }
			end
			return
		end

		offset = params[:offset].to_i

		round = Round.first
		notifications = current_user
				.notifications
				.where(created_at: Time.at(round.endTime.to_i - round.duration * 2)
				.to_datetime..Time.now)
				.order('created_at ASC')
		notifications = notifications.slice(offset..offset)

		response = { :size => notifications.size, :notifications => notifications }
		respond_to do |format|
			format.json { render json: response }
		end
	end
end
