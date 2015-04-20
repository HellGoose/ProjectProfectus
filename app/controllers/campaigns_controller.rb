class CampaignsController < ApplicationController
	before_action :set_campaign, only: [:show, :edit, :update, :destroy]

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

      embedly = Embedly::API.new :key => '0eef325249694df490605b1fd29147f5'

      obj = embedly.extract :url => @campaign.link
      o = obj.first

      @campaign.title = o.title
      @campaign.description = o.description			

      respond_to do |format|
      if @campaign.save
          current_user.points +=107
          current_user.save
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
        campaign_id = params[:id].to_i
        campaigns = current_user.campaignVotes.where(step: current_user.isOnStep)

        for i in 0..2
          campaigns[campaign_id / 3 + i].voteType = 0
          campaigns[campaign_id / 3 + i].save
        end

        campaigns[campaign_id].voteType = 1
        campaigns[campaign_id].save
        current_user.isOnStep += 1
        current_user.save

        if current_user.isOnStep >= 3
          current_user.campaignVotes.where(voteType: 1).each do |v|
            v.campaign.roundScore += 1
            v.campaing.save
          end
          bestCampaign = current_user.campaignVotes.find_by(voteType: 2).campaign
          bestCampaign.roundScore += 10
          bestCampaign.save
          render :nothing => true
        else

        	campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
          @campaignVoting = []
          for i in 0..2
            @campaignVoting << campaignVotes[i].campaign
          end

          respond_to do |format|
            format.js { render partial: 'campaignVoting' }
          end
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
