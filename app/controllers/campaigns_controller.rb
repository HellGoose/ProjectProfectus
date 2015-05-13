class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :edit, :update, :destroy]

	# Public: Prepares variables for campaign#index.
	# Route: GET root/campaigns/
	#
	# @campaigns 				 - All campaigns present in the database.
	# @campaignsInterval - Number of campaigns shown per page.
	#
	# Renders campaign#index.
	def index
		@campaigns = Campaign.all.order("(globalScore + roundScore) DESC")
		@campaignsInterval = 8
	end

	# Public: Prepares variables for campaign#new.
	# Route: GET root/campaigns/new
	#
	# @campaign - Placeholder for the "new campaign" form.
	#
	# Renders campaign#new.
	def new
		@campaign = Campaign.new
	end

	# Public: Prepares variables for campaign#show.
	# Route: GET root/campaigns/:id
	# 	:id - The id of the campaign in the database.
	#
	# @postInterval - All campaigns present in the database.
	# @posts 				- Number of campaigns shown per page.
	# @post 				- Placeholder for the "new post" form
	#
	# Renders campaign#show.
	def show
		@postsInterval = 10
		@posts = @campaign.posts.where(isComment: false).order("voteCount DESC")
		@post = Post.new
	end

	# Public: Prepares variables for campaign#edit.
	# Route: GET root/campaigns/:id/edit
	# 	:id - The id of the campaign in the database.
	#
	# Renders campaign#edit.
	def edit
	end

	# Public: Updates a campaign iff the current user is the campaign owner or an admin.
	# Route: PUT root/campaigns/:id
	# 	:id - The id of the campaign in the database.
	#
	# Renders campaign#show iff the update succeeds, else rerenders campaign#edit with the error.
	def update
		respond_to do |format|
			if (isCampaignOwner or isAdmin) and @campaign.update(campaign_params)
				msg = "<span class=\"alert alert-success\">Campaign was successfully updated.</span>"
				format.html { redirect_to @campaign, notice: msg }
				format.json { render :show, status: :ok, location: @campaign }
			else
				format.html { render :edit }
				format.json { render json: @campaign.errors, status: :unprocessable_entity }
			end
		end
	end

	# Public: Creates a new campaign.
	# Route: POST root/campaigns/
	#
	# @campaign 	- The campaign to be added in the database.
	# embedly 	 	- An instance of the Embedly API used for scraping data off websites.
	# embedlyData - The relevant data scraped from the given URL.
	# whiteList		- A list of all allowed provider_URLs.
	#
	# Renders campaign#index.
	def create
		if current_user
			@campaign = Campaign.new(campaign_params)
			@campaign.user_id = session[:user_id]

			embedly = Embedly::API.new key: "0eef325249694df490605b1fd29147f5"
			embedlyData = (embedly.extract url: @campaign.link).first
			kickstarterURL = "https://www.kickstarter.com"
			indigogoURL = "http://www.indiegogo.com"
			whiteList = [kickstarterURL,indigogoURL]

			case embedlyData.provider_url
			when *whiteList
				embedlyData.title.slice!("CLICK HERE to support ")
				@campaign.title = embedlyData.title
				@campaign.description = embedlyData.description.encode('utf-8', 'binary', invalid: :replace, undef: :replace, replace: '')

				respond_to do |format|
					if @campaign.save
						current_user.points +=107
						current_user.save
						msg = "<span class=\"alert alert-success\">Campaign was successfully created.</span>"
						format.html { redirect_to @campaign, notice: msg }
						format.json { render :show, status: :created, location: @campaign }
					else
						format.html { render :new }
						format.json { render json: @campaign.errors, status: :unprocessable_entity }
					end
				end
			else
				respond_to do |format|
					format.html { render :new }
					format.json { render json: @campaign.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# Public: Deletes a campaign from the database.
	# Route: DELETE root/campaigns/:id
	# 	:id - The id of the campaign in the database.
	#
	# Renders user#show iff the deletion succeeded, else renders campaign#show with the error.
	def destroy
		respond_to do |format|
			if (isCampaignOwner or isAdmin) and @campaign.destroy
				msg = "<span class=\"alert alert-success\">Campaign was successfully destroyed.</span>"
				format.html { redirect_to @campaign.user, notice: msg }
				format.json { head :no_content }
			else
				msg = "<span class=\"alert alert-warning\">You cannot delete this campaign.</span>"
				format.html { redirect_to @campaign, notice: msg }
				format.json { head :no_content }
			end
		end
	end

	# Public: Processes vote requests for campaigns. Including: Voting, initiating and resuming.
	# Route: GET root/vote/campaign/:id
	# 	:id - The id of the campaign relative to the current voting step.
	#
	# current_user.isOnStep - The voting step the current user is on.
	# 	isOnStep <  4 - The vote is processed.
	#  	isOnStep == 4 - The user is done voting, and the result is rendered.
	#
	# Renders the next voting step iff the user is logged in. else 
	# renders an error if the user is not logged in or there are not enough 
	# campaigns in the database.
	def vote
		if Campaign.all.count < 15
			respond_to do |format|
				format.js { render partial: "home/not_enough_campaigns"}
			end
		elsif current_user and current_user.isOnStep <= 4
			if params[:id].to_i >= 0 and current_user.isOnStep < 4
				processVote(params[:id].to_i)
				current_user.isOnStep += 1
				current_user.save
			end

			@campaignVoting = []
			setUpNextVotingStep

			if current_user.isOnStep == 4
				respond_to do |format|
					format.js { render partial: "campaignVotingDone"}
				end
			elsif current_user.isOnStep < 4
				respond_to do |format|
					format.js { render partial: "campaignVoting"}
				end
			else
				render nothing: true
			end
		else
			respond_to do |format|
				format.js { render partial: "home/not_logged_in"}
			end
		end
	end

	# Public: Gets the size of the current array of filtered campaigns.
	# Route: GET root/campaigns/page/:category/:searchText
	# 	:category 	- The id of the category in the database.
	# 	:searchText - Input from the search field.
	#
	# category   - The category used to filter the campaigns.
	# searchText - The searchText used to filter the campaigns.
	# campaigns	 - The current array of filtered campaigns.
	#
	# Returns the size of the current array of filtered campaigns.
	def size
		category = 0
		searchText = " "
		category = params[:category].to_i if params[:category] != nil
		searchText = params[:searchText].gsub("_", " ") if params[:searchText] != nil

		campaigns = search(searchText, category)
		
		respond_to do |format|
			msg = { status: "ok", message: campaigns.size }
			format.json	{ render json: msg }
		end
	end

	# Public: Filters out which campaigns to be rendered on a page.
	# Route: root/campaigns/page/:category/:page/:interval/:sortBy/:searchText
	# 	:category 	- The id of the category in the database.
	# 	:page 			- The current page.
	# 	:interval 	- Campaigns per page.
	# 	:sortBy			- The variables to sort by (String in MySQL sortBy syntax).
	# 	:searchText - Input from the search field.
	#
	# @campaigns 				 - All campaigns present in the database.
	# @campaignsInterval - Number of campaigns shown per page.
	#
	# Renders campaign#index.
	def page
		page = params[:page]
		interval = params[:interval]
		category = 0
		sortBy = " "
		searchText = " "
		category = params[:category].to_i if params[:category] != nil
		sortBy = params[:sortBy].tr("_", " ") if params[:sortBy] != nil
		searchText = params[:searchText].tr("_", " ") if params[:searchText] != nil

		@campaigns = search(searchText, category).order(sortBy)
		
		respond_to do |format|
			format.html { render partial: "campaignList", locals: { page: page, campaignsPerPage: interval}}
		end
	end

	private

	# Private: Checks if the current user owns the given campaign.
	#
	# @campaign - The given campaign.
	#
	# Returns true if the current user is the owner.
	def isCampaignOwner
		@campaign.user_id == session[:user_id]
	end

	# Private: Makes the a campaign globally accessible.
	#
	# @campaign - The globally accessible campaign.
	#
	# Returns the campaign.
	def set_campaign
		@campaign = Campaign.find(params[:id])
	end

	# Private: Checks if the fields of the given parameters are allowed.
	#
	# params - The parameters to check.
	#
	# Returns the parameters iff the parameters are allowed.
	def campaign_params
		params.require(:campaign).permit(:title, :description, :image, :link, :category_id)
	end

	# Private: Searches for strings in description and title matching a search text.
	#
	# text 		 - The text to search for.
	# SQLStmnt - The SQL statement to search with.
	# category - The category to search in.
	#
	# Returns an array of campaigns filtered by the search text and category.
	def search(text, category)
		text = "%#{text}%"
		stmntSQL = "title LIKE ? OR description LIKE ? COLLATE utf8_general_ci"
		if category > 0
			category = Category.find(category)
			category.campaigns.where(stmntSQL, text, text)
		else
			Campaign.where(stmntSQL, text, text)
		end
	end

	# Private: Processes a campaign vote.
	#
	# campaigns 						- The campaigns corresponding to the current step.
	# current_user.isOnStep - The voting step the current user is on.
	# 	isOnStep <  3 - Process vote (voteType = 1). 
	#  	isOnStep == 3 - Process last vote (voteType = 2) and give points to the user and campaigns.
	#
	# Returns nothing.
	def processVote(campaign_id)
		case current_user.isOnStep
		when 0..2
			campaigns = current_user.campaignVotes.where(step: current_user.isOnStep)

			(0..2).each do |i|
				next if campaigns[i] == nil
				campaigns[i].voteType = 0
				campaigns[i].save
			end
			campaigns[campaign_id].voteType = 1
			campaigns[campaign_id].save
		when 3
			campaigns = current_user.campaignVotes.where.not(voteType: 0)

			campaigns[campaign_id].voteType = 2
			campaigns[campaign_id].save
			campaigns[campaign_id].campaign.roundScore += 10
			campaigns[campaign_id].campaign.save

			current_user.points += 4
			current_user.campaignVotes.where(voteType: 1).each do |v|
				v.campaign.roundScore += 1
				v.campaign.save
			end
		end
	end

	# Private: Sets up the next voting step or resumes where the user left off.
	#
	# campaignVotes 	- The campaigns the user can choose from this round.
	# @votedFor 			- The campaign that the user marked as best.
	# @campaignVoting - The campaigns corresponding to the current step.
	#
	# Returns nothing.
	def setUpNextVotingStep
		if current_user.campaignVotes == [] and current_user.isOnStep <= 4
			campaignVotes = genCampaignsForVoting
		elsif current_user.isOnStep >= 3
			campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
			@votedFor = current_user.campaignVotes.where(voteType: 2)
		else
			campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
		end

		for i in 0..2
			next if (campaignVotes[i] == nil)
			@campaignVoting << campaignVotes[i].campaign
		end
	end

	# Private: Generates campaigns for the user to compare and vote for.
	#
	# campaignVotes  - A reference to the association User.campaignVotes.
	# genedCampaigns - The campaigns generated.
	#
	# Returns the campaigns corresponding to the current step.
	def genCampaignsForVoting
		current_user.isOnStep = 0
		campaignVotes = current_user.campaignVotes
		genedCampaigns = []

		campaigns = Campaign.order("(roundScore + globalScore) DESC")
		genedCampaigns << campaigns.last(campaigns.size * 0.5).sample(3)
		genedCampaigns << campaigns.slice((campaigns.size * 0.2)..(campaigns.size * 0.5)).sample(3)
		genedCampaigns << campaigns.first(campaigns.size * 0.2).sample(3)

		(0..8).each do |i|
			step = (i / 3).to_i
			campaignVotes.create(user_id: current_user.id, campaign_id: genedCampaigns[step][i % 3].id, step: step)
		end

		current_user.save
		current_user.campaignVotes.where(step: current_user.isOnStep)
	end
end