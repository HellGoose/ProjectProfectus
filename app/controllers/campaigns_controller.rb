class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:vote, :show, :edit, :update, :destroy]

	def index
		@campaigns = Campaign.all.order('voteCount DESC')
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
        		format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
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

      		respond_to do |format|
        	if @campaign.save
          		format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
          		format.json { render :show, status: :created, location: @campaign }
       		else
          		format.html { render :new }
          		format.json { render json: @campaign.errors, status: :unprocessable_entity }
        		end
      		end
    	end
	end

	def destroy
	    respond_to do |format|
			if (isCampaignOwner or isAdmin) && @campaign.destroy
				format.html { redirect_to @campaign, notice: 'Campaign was successfully destroyed.' }
				format.json { head :no_content }
			else
				format.html { redirect_to @campaign, notice: 'You cannot delete this campaign.' }
				format.json { head :no_content }
			end
		end
	end

	def vote
    	if current_user
    		userVote = @campaign.votes.find_by(user_id: session[:user_id])
    		if (userVote == nil)
        		userVote = @campaign.votes.create(campaign_id: @campaign.id, user_id: session[:user_id])
        		if params[:dir] == 'up'
        			@campaign.voteCount += 1
        			userVote.isDownvote = false
        		elsif params[:dir] == 'down'
        			@campaign.voteCount -= 1
        			userVote.isDownvote = true
        		end        
    		else
    			if params[:dir] == 'up' and userVote.isDownvote != false
        			userVote.isDownvote = false
        			@campaign.voteCount += 2
        		elsif params[:dir] == 'down' and userVote.isDownvote != true
        			userVote.isDownvote = true
        			@campaign.voteCount -= 2
    			end
    		end
      		userVote.save
      		@campaign.save
      		respond_to do |format|
        		msg = { :status => "ok", :message => @campaign.voteCount }
        		format.json  { render :json => msg }
      		end
    	end
  	end

  def page
    if params[:category].to_i > 0
      category = Category.find(params[:category])
      @campaigns = category.campaigns.order('voteCount DESC')
    else
      @campaigns = Campaign.all.order('voteCount DESC')
    end
    page = params[:page]
    interval = params[:interval]
    respond_to do |format|
      format.js { render partial: 'campaignList', locals: { page: page, campaignsPerPage: interval } }
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
end