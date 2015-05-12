class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :edit, :update, :destroy]

	def index
		@campaigns = Campaign.all.order('(globalScore + roundScore) DESC')
		@campaignsInterval = 8
	end

	def new
		@campaign = Campaign.new
	end

	def show
		@postsInterval = 10
		@posts = @campaign.posts.where('isComment = 0').order('voteCount DESC')
		@post = Post.new
	end

	def edit
	end

	def update
		respond_to do |format|
			if (isCampaignOwner or isAdmin) && @campaign.update(campaign_params)
				format.html { redirect_to @campaign, notice: '<span class="alert alert-success">Campaign was successfully updated.</span>' }
				format.json { render :show, status: :ok, location: @campaign }
			else
				format.html { render :edit }
				format.json { render json: @campaign.errors, status: :unprocessable_entity }
			end
		end
	end

	def create
		if current_user
			@campaign = Campaign.new(campaign_params)
			@campaign.user_id = session[:user_id]

			embedly = Embedly::API.new :key => '0eef325249694df490605b1fd29147f5'

			obj = embedly.extract :url => @campaign.link
			o = obj.first

			if o.provider_url == 'https://www.kickstarter.com' or o.provider_url == 'http://www.indiegogo.com'
				@campaign.title = o.title
				@campaign.description = o.description			

				respond_to do |format|
					if @campaign.save
						current_user.points +=107
						current_user.save
							format.html { redirect_to @campaign, notice: '<span class="alert alert-success">Campaign was successfully created.</span>' }
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

	def destroy
		respond_to do |format|
			if (isCampaignOwner or isAdmin) && @campaign.destroy
				format.html { redirect_to @campaign.user, notice: '<span class="alert alert-success">Campaign was successfully destroyed.</span>' }
				format.json { head :no_content }
			else
				format.html { redirect_to @campaign, notice: '<span class="alert alert-warning">You cannot delete this campaign.</span>' }
				format.json { head :no_content }
			end
		end
	end

	def vote
		if Campaign.all.count < 15
			respond_to do |format|
				format.js { render partial: 'home/not_enough_campaigns'}
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
					format.js { render partial: 'campaignVotingDone'}
				end
			elsif current_user.isOnStep < 4
				respond_to do |format|
					format.js { render partial: 'campaignVoting'}
				end
			else
				render nothing: true
			end
		else
			respond_to do |format|
				format.js { render partial: 'home/not_logged_in'}
			end
		end
	end

  def size
    category = 0
    searchText = ' '
    category = params[:category].to_i if params[:category] != nil
    searchText = params[:searchText].gsub('_', ' ') if params[:searchText] != nil

    @campaigns = search(searchText, category)
    
    respond_to do |format|
      msg = { status: "ok", message: @campaigns.size }
      format.json  { render json: msg }
    end
  end

	def page
		page = params[:page]
		interval = params[:interval]
		category = 0
		sortBy = ' '
		searchText = ' '
		category = params[:category].to_i if params[:category] != nil
		sortBy = params[:sortBy].gsub('_', ' ') if params[:sortBy] != nil
		searchText = params[:searchText].gsub('_', ' ') if params[:searchText] != nil

		@campaigns = search(searchText, category).order(sortBy)
		
		respond_to do |format|
			format.html { render partial: 'campaignList', locals: { page: page, campaignsPerPage: interval}}
		end
	end

	private
		def isCampaignOwner
			@campaign.user_id == session[:user_id]
		end

		def set_campaign
			@campaign = Campaign.find(params[:id])
		end

		def campaign_params
			params.require(:campaign).permit(:title, :description, :image, :link, :category_id)
		end

		def search(text, category)
			search_condition = "%" + text + "%"
			if category > 0
				category = Category.find(category)
				category.campaigns.where('title LIKE ? OR description LIKE ? COLLATE utf8_general_ci', search_condition, search_condition)
			else
				Campaign.where('title LIKE ? OR description LIKE ? COLLATE utf8_general_ci', search_condition, search_condition)
			end
		end

		def processVote(campaign_id)
			if current_user.isOnStep < 3
				campaigns = current_user.campaignVotes.where(step: current_user.isOnStep)

				for i in 0..2
					next if campaigns[i] == nil
					campaigns[i].voteType = 0
					campaigns[i].save
				end
				campaigns[campaign_id].voteType = 1
				campaigns[campaign_id].save
			elsif current_user.isOnStep == 3
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

		def genCampaignsForVoting
			current_user.isOnStep = 0
			campaignVotes = current_user.campaignVotes
			genedCampaigns = []

			campaigns = Campaign.order("(roundScore + globalScore) DESC")

			genedCampaigns << campaigns.last(campaigns.size * 0.5).sample(3)
			genedCampaigns << campaigns.slice((campaigns.size * 0.2)..(campaigns.size * 0.5)).sample(3)
			genedCampaigns << campaigns.first(campaigns.size * 0.2).sample(3)

			for i in 0..8
				step = (i / 3).to_i
				campaignVotes.create(user_id: current_user.id, campaign_id: genedCampaigns[step][i % 3].id, step: step)
			end

			current_user.save
			current_user.campaignVotes.where(step: current_user.isOnStep)
		end
end