class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :edit, :update, :destroy]
	skip_before_action :verify_authenticity_token

	# Public: Prepares variables for campaign#index.
	# Route: GET root/campaigns/
	#
	# @campaigns 				 - All campaigns present in the database.
	# @campaignsInterval - Number of campaigns shown per page.
	#
	# Renders campaign#index.
	def index
		@campaigns = Campaign.where(status: "ready").order("created_at DESC")
		@campaignsInterval = 16
	end

	# Public: Prepares variables for campaign#new.
	# Route: GET root/campaigns/new
	#
	# @campaign - Placeholder for the "new campaign" form.
	#
	# Renders campaign#new.
	def new
		if current_user && current_user.additionsThisRound < Round.first.maxAdditionsPerUser
			@campaign = Campaign.new
		else
			respond_to do |format|
				msg = "<span class=\"alert alert-warning\">You have exceeded your submission limit for this round.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
		end
	end

	# Public: Prepares variables for campaign#show.
	# Route: GET root/campaigns/:id
	# 	:id - The id of the campaign in the database.
	#
	# @posts 				- All posts present in the database. 
	# @postInterval	- Number of campaigns shown per page.
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
	# @campaign - The campaign to update.
	#
	# Renders campaign#show iff the update succeeds, 
	# otherwise rerenders campaign#edit with the error.
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
		t2 = Time.now
		if !current_user || current_user.additionsThisRound >= Round.first.maxAdditionsPerUser
			respond_to do |format|
				msg = "<span class=\"alert alert-warning\">You have exceeded your submission limit for this round.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
			return
		end

		@campaign = Campaign.new(campaign_params)

		link = campaign_params[:link]
		provider = link.sub("https://", "").sub("http://", "").split("/")[0]

		case provider
		when *Crowdfunding_site.pluck(:domain)
			if Campaign.exists?(link: link)
				nominate(link, provider)
			else
				add(provider)
			end
		else
			repond_to do |format|
				msg = "<span class=\"alert alert-warning\">The site this URL is pointing at is not supported.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
		end
		p "Everything: " + (Time.now - t2).to_s
	end

	# Public: Checks if a campaign can be nominated
	def check_if_can_add
		campaign = Campaign.where("link REGEXP ?", "[/]#{params[:title]}([/#?]|$)")[0]
		respond_to do |format|
			if !current_user
				format.json { render json: { 'User' => 'not logged in' } }
			elsif !campaign && current_user.additionsThisRound >= Round.first.maxAdditionsPerUser
				format.json { render json: { 'User' => 'too many campaigns nominated' } }
			elsif !campaign && current_user.additionsThisRound < Round.first.maxAdditionsPerUser
				format.json { render json: { 'Campaign' => 'was not found' } }
			elsif campaign.nominated
				format.json { render json: { 'Campaign' => 'nominated: true' } }
			elsif current_user.additionsThisRound >= Round.first.maxAdditionsPerUser
				format.json { render json: { 'User' => 'too many campaigns nominated' } }
			else
				format.json { render json: { 'Campaign' => 'nominated: false' } }
			end
		end
	end

	# Public: Deletes a campaign from the database.
	# Route: DELETE root/campaigns/:id
	# 	:id - The id of the campaign in the database.
	#
	# @campaign - The campaign to be deleted.
	#
	# Renders user#show iff the deletion succeeded,
	# otherwise renders campaign#show with the error.
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
	# 	isOnStep <	4 - The vote is processed.
	# 	isOnStep == 4 - The user is done voting, and the result is rendered.
	#
	# Renders the next voting step iff the user is logged in. else 
	# renders an error if the user is not logged in or there are not enough 
	# campaigns in the database.
	def vote
		if Campaign.where(votable: true).count < 15
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
			else
				respond_to do |format|
					format.js { render partial: "campaignVoting"}
				end
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
		sortBy = params[:sortBy].tr("-", " ") if params[:sortBy] != nil
		searchText = params[:searchText].tr("-", " ") if params[:searchText] != nil

		@campaigns = search(searchText, category).order(sortBy)
		
		respond_to do |format|
			format.html { render partial: "campaignList", locals: { page: page, campaignsPerPage: interval}}
		end
	end

	def refresh_step
		if Campaign.where(votable: true).count <= 30
			if campaign.where(votable: true).count < 15
				respond_to do |format|
					format.js { render partial: "home/not_enough_campaigns"}
				end
			else
				respond_to do |format|
					format.js { render partial: "campaignVoting"}
				end
			end
		elsif current_user.isOnStep < 3
			@campaignVoting = []
			campaignVotes = genCampaignsForVoting(current_user.isOnStep)
			for i in 0..2
				next if campaignVotes[i].nil?
				@campaignVoting << campaignVotes[i].campaign
			end

			respond_to do |format|
				format.js { render partial: "campaignVoting"}
			end
		else
			respond_to do |format|
				format.js { render partial: "home/not_logged_in"}
			end
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
			category.campaigns.where(stmntSQL, text, text).where(status: "ready")
		else
			Campaign.where(stmntSQL, text, text).where(status: "ready")
		end
	end

	def nominate(link, provider)
		@campaign = Campaign.find_by(link: link) 

		if @campaign.nominated
			respond_to do |format|
				msg = "<span class=\"alert alert-warning\">This campaign has already been nominated.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
			return
		end

		@campaign.nominated = true
		@campaign.nominator_id = current_user.id
		if @campaign.crowdfunding_site_id.nil?
			@campaign.crowdfunding_site_id = Crowdfunding_site.find_by(domain: provider).id
		end

		if @campaign.save
			notification = PointsHistory.new(description: 'You successfully made a nomination!', points_received: 5)

			current_user.pointsHistories << notification
			current_user.points +=5
			current_user.additionsThisRound += 1
			current_user.save

			respond_to do |format|
				msg = "<span class=\"alert alert-success\">Campaign was successfully nominated.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
		else
			respond_to do |format|
				format.html { render :new }
				format.json { render json: @campaign.errors, status: :unprocessable_entity }
			end
		end
	end

	def add(provider)
		@campaign.status = "adding"
		@campaign.nominated = true
		@campaign.votable = false
		@campaign.user_id = session[:user_id]
		@campaign.nominator_id = session[:user_id]
		@campaign.crowdfunding_site_id = Crowdfunding_site.find_by(domain: provider).id
		if @campaign.save
			current_user.additionsThisRound += 1
			current_user.save
			threaded_diffbot_add(@campaign, provider)
			respond_to do |format|
				msg = "<span class=\"alert alert-success\">Your campaign is beeing added. This may take some time.</span>"
				format.html { redirect_to current_user, notice: msg }
				format.json { render :show, location: current_user }
			end
		else
			respond_to do |format|
				format.html { render :new }
				format.json { render json: @campaign.errors, status: :unprocessable_entity }
			end
			return
		end
	end

	def threaded_diffbot_add(campaign, provider)
		t = Thread.new {
			t1 = Time.now

			api_key = '6cc89ec29944d6980a8635b0999dfa71'
			url = URI.parse('http://api.diffbot.com/v3/article?token=' + api_key + '&url=' + URI.encode(campaign.link, /\W/))
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http|
				http.request(req)
			}

			p "Diffbot: " + (Time.now - t1).to_s
			t1 = Time.now

			j = JSON.parse res.body

			campaign.lock!
			campaign.title = j['objects'][0]['title'].delete('.')
			campaign.content = j['objects'][0]['html']
			campaign.backers = j['objects'][0]['backers'].delete(',').to_i
			campaign.pledged = j['objects'][0]['pledged'].delete(',').delete('$').to_i # only dollahs?
			campaign.goal = j['objects'][0]['goal'].delete(',').delete('$').to_i
			campaign.author = j['objects'][0]['author'] # needs proper parsing for kickstarter
			campaign.image = j['objects'][0]['image']
			campaign.description = j['objects'][0]['description']

			p provider

			if provider.include? "indiegogo"
				link = campaign.link.sub "/projects/", "/project/"
				link = link.split("#")[0] + "/embedded"

				url = URI.parse('http://api.diffbot.com/v3/article?token=' + api_key + '&url=' + URI.encode(link, /\W/))
				req = Net::HTTP::Get.new(url.to_s)
				res = Net::HTTP.start(url.host, url.port) {|http|
					http.request(req)
				}

				k = JSON.parse res.body

				image = k['objects'][0]['image']

				if !image.nil?
					image.sub! "h_220", "h_355"
					image.sub! "w_220", "w_475"
				end

				campaign.image = image
			end

			if campaign.image.nil?
				campaign.image = j['objects'][0]['images'][0]['url']
			end

			#case embedlyData.provider_url
			#when kickstarterURL
			#	@campaign.end_time = j['objects'][0]['date']
			#when indigogoURL
			#	@campaign.end_time = j['objects'][0]['date']
			#end

			p "Parsing: " + (Time.now - t1).to_s
			campaign.status = "ready"
			if campaign.save
				notification = PointsHistory.new(description: 'Campaign successfully nominated!', points_received: 5)
				user = current_user.lock!
				user.pointsHistories << notification
				user.points +=5
				user.save
			else
				notification = PointsHistory.new(description: 'Campaign was not nominated! Something went wrong.', points_received: 0)
				user = current_user.lock!
				user.pointsHistories << notification
				user.additionsThisRound -= 1
				user.save
				@campaign.destroy
			end
			ActiveRecord::Base.connection.close
		}
		at_exit {t.join}
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
			campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
			(0..2).each do |i|
				next if campaignVotes[i].nil?
				campaignVotes[i].voteType = 0
				campaignVotes[i].save
			end
			campaignVotes[campaign_id].voteType = 1
			campaignVotes[campaign_id].save
		when 3
			campaignVotes = current_user.campaignVotes.where.not(voteType: 0)

			campaignVotes[campaign_id].voteType = 2
			campaignVotes[campaign_id].save
			campaignVotes[campaign_id].campaign.roundScore += 10
			campaignVotes[campaign_id].campaign.save

			notification = PointsHistory.new(description: 'Someone voted for your nominee!', points_received: 1)
			campaignVotes[campaign_id].campaign.user.pointsHistories << notification
			campaignVotes[campaign_id].campaign.user.points += 1
			campaignVotes[campaign_id].campaign.user.save

			notification = PointsHistory.new(description: 'You successfully voted this round!', points_received: 1)
			current_user.pointsHistories << notification
			current_user.points += 1
			current_user.save
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
		step = current_user.isOnStep
		if  step < 3 and current_user.campaignVotes.where(step: step).empty?
			campaignVotes = genCampaignsForVoting(step)
		elsif step >= 3
			campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
			@votedFor = current_user.campaignVotes.where(voteType: 2)
		else
			campaignVotes = current_user.campaignVotes.where(step: step)
		end

		for i in 0..2
			next if campaignVotes[i].nil?
			@campaignVoting << campaignVotes[i].campaign
		end
	end

	# Private: Generates campaigns for the user to compare and vote for.
	#
	# campaignVotes  - A reference to the association User.campaignVotes.
	# genedCampaigns - The campaigns generated.
	#
	# Returns the campaigns corresponding to the current step.
	def genCampaignsForVoting(step)
		campaigns = Campaign.where(votable: true).order("timesShownInVoting DESC")
		genedCampaigns = []

		case step
		when 0
			genedCampaigns = campaigns.last(campaigns.size * 0.2)
		when 1
			genedCampaigns = campaigns.slice((campaigns.size * 0.5)..(campaigns.size * 0.8))
		when 2
			genedCampaigns = campaigns.first(campaigns.size * 0.5)
		end

		campaignVotes = current_user.campaignVotes
		campaignVotes.where(step: step).each{|cv| cv.destroy}
		votedCampaigns = []
		campaignVotes.each{|cv| votedCampaigns << cv.campaign}

		genedCampaigns = (genedCampaigns - votedCampaigns).sample(3)
		genedCampaigns.each do |gc|
			campaignVotes.create(
				user_id: current_user.id, 
				campaign_id: gc.id, 
				step: step)
			gc.timesShownInVoting += 1
			gc.save
		end

		current_user.save
		current_user.campaignVotes.where(step: step)
	end
end
