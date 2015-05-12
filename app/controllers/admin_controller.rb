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
		@newsInterval = 5
		@all_news = News.order("created_at DESC")
		@news = News.new
		#@flagged = Project.all.where('flagged > 0')
		if !isAdmin
			redirect_to '/'
		end
	end

	# Handles requests for administrating round variables.
	# Route: root/admin/round/:type/:val
	# 	:type - Type of action. Can be: 'update', 'force', 'error'
	# 	:val  - Duration in seconds. Only used for :type == 'update'
	#
	# params[:type] == 'update': Updates the duration of the next Round.
	# params[:type] == 'force':  Forces a new Round(Round timer will NOT be reset).
	# params[:type] == 'error':  Displays error message for illegal input.
	#
	#
	# If the user is an admin, renders admin#index. Else, redirects to root.
	#Handles requests for administrating round variables
	def round
		round = Round.lock.first

		if params[:type] == 'update'
			round.duration = params[:val].to_i
			durationInWords = view_context.distance_of_time_in_words(round.duration)
			respond_to do |format|
				msg = '<span class="alert alert-success">Duration updated to #{durationInWords}</span>'
				format.json { render json: { status: 'ok', message: msg } }
			end
		elsif params[:type] == 'force'
			round.forceNewRound = true
			respond_to do |format|
				msg = '<span class="alert alert-success">Forcing new round!</span>'
				format.json { render json: { status: 'ok', message: msg } }
			end
		elsif params[:type] == 'error'
			respond_to do |format|
				msg = '<span class="alert alert-warning">Invalid input. Only positive numbers.</span>'
				format.json { render json: { status: 'ok', message: msg } }
			end
		end

		round.save
	end
end
