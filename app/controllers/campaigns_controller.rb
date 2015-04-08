class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :edit, :update, :destroy]

	def index
		@campaigns = Campaign.all.order('voteCount DESC')
		@campaignsInterval = 8
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

	def new
		@campaign = Campaign.new
	end

	def show
		@postsInterval = 10
		@posts = @campaign.posts.where('isComment = 0').order('voteCount DESC')
		@post = Post.new
	end

	def create
		if current_user
			@campaign = Campaign.new(campaign_params)
      		@campaign.user_id = session[:user_id]

      		respond_to do |format|
        	if @campaign.save
          		format.html { redirect_to @campaign, notice: 'campaign was successfully created.' }
          		format.json { render :show, status: :created, location: @campaign }
       		else
          		format.html { render :new }
          		format.json { render json: @campaign.errors, status: :unprocessable_entity }
        		end
      		end
    	end
	end

	private
		def set_campaign
      		@campaign = Campaign.find(params[:id])
    	end

		def campaign_params
			params.require(:campaign).permit(:title, :description, :image, :link)
		end
end
