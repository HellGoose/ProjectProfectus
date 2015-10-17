class AdminController < ApplicationController
	
	# Public: Prepares variables for admin#index.
	# Route: root/admin/
	#
	# @newsInterval - Number of news shown before the "show more" button
	# @allNews 		- All news present in the database.
	# @news 		- Placeholder for the "add news" form.
	#
	# If the user is an admin, renders admin#index. Else, redirects to root.
	def index
		if !isAdmin
			redirect_to '/'
			return
		end
		@newsInterval = 5
		@allNews = News.order("created_at DESC")
		@news = News.new
		@statDumps = []
		if !StatDump.all.empty?
			@statDumps = StatDump.order("created_at DESC")
		end
		@reportedCampaigns = Campaign.where("reported > 0").order("reported DESC").first(20)
	end

	# Handles requests for administrating round variables.
	# Route: root/admin/round/:type/:val
	# 	:type - Type of action. Can be: "update", "force", "error"
	# 	:val  - Duration in seconds. Only used for :type == "update"
	#
	# params[:type] == "update": Updates the duration of the next Round.
	# params[:type] == "force":  Forces a new Round(Round timer will NOT be reset).
	#
	# Handles requests for administrating round variables
	def round
		if !isAdmin
			redirect_to '/'
			return
		end
		round = Round.lock.first

		case params[:type]
		when "update"
			round.duration = params[:val].to_i
			durationInWords = view_context.distance_of_time_in_words(round.duration)
			respond_to do |format|
				msg = "<span class=\"alert alert-success\">Duration updated to #{durationInWords}</span>"
				format.json { render json: { status: "ok", message: msg } }
			end
		when "force"
			round.forceNewRound = true
			respond_to do |format|
				msg = "<span class=\"alert alert-success\">Forcing new round!</span>"
				format.json { render json: { status: "ok", message: msg } }
			end
		end

		round.save
	end

	def clear_all_nominations
		if !isAdmin
			redirect_to '/'
			return
		end
		User.update_all(additionsThisRound: 0)
		Campaign.update_all(nominated: false)
		redirect_to "/admin/"
	end

	def nominate_all
		if !isAdmin
			redirect_to '/'
			return
		end
		Campaign.update_all(nominated: true)
		redirect_to "/admin/"
	end

	def reset_voting
		if !isAdmin
			redirect_to '/'
			return
		end
		CampaignVote.destroy_all
		Campaign.update_all(timesShownInVoting: 0, roundScore: 0)
		User.update_all(isOnStep: 0)
		redirect_to "/admin/"
	end

	def clear_campaign
		if !isAdmin
			redirect_to '/'
			return
		end

		campaign = Campaign.find(params[:id])
		campaign.reported = 0
		campaign.reportedBy.destroy_all
		campaign.save

		@reportedCampaigns = Campaign.where("reported > 0").order("reported DESC").first(20)
		render partial: "reported_campaigns"
	end

	def delete_campaign
		if !isAdmin
			redirect_to '/'
			return
		end
		
		campaign = Campaign.find(params[:id])
		campaign.destroy

		@reportedCampaigns = Campaign.where("reported > 0").order("reported DESC").first(20)
		render partial: "reported_campaigns"
	end
end
