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
    end
	end

	def destroy
	    respond_to do |format|
			if (isCampaignOwner or isAdmin) && @campaign.destroy
				format.html { redirect_to @campaign, notice: '<span class="alert alert-success">Campaign was successfully destroyed.</span>' }
				format.json { head :no_content }
			else
				format.html { redirect_to @campaign, notice: '<span class="alert alert-warning">You cannot delete this campaign.</span>' }
				format.json { head :no_content }
			end
		end
	end

	def vote
    	if current_user and current_user.isOnStep < 4
        campaign_id = params[:id].to_i

        if current_user.isOnStep < 3
          campaigns = current_user.campaignVotes.where(step: current_user.isOnStep)

          for i in 0..2
            next if campaigns[campaign_id / 3 + i] == nil
            campaigns[campaign_id / 3 + i].voteType = 0
            campaigns[campaign_id / 3 + i].save
          end

          campaigns[campaign_id].voteType = 1
          campaigns[campaign_id].save
        elsif current_user.isOnStep == 3
          campaigns = current_user.campaignVotes.where.not(voteType: 0)

          campaigns[campaign_id].voteType = 2
          campaigns[campaign_id].save
          
          campaigns[campaign_id].campaign.roundScore += 10
          campaigns[campaign_id].campaign.save

          current_user.points += 3

          current_user.campaignVotes.where(voteType: 1).each do |v|
            v.campaign.roundScore += 1
            v.campaign.save
          end
        end

        current_user.isOnStep += 1
        current_user.save

        if current_user.isOnStep == 4
          campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
          @votedFor = current_user.campaignVotes.where(voteType: 2)

          @campaignVoting = []
          for i in 0..2
            next if campaignVotes[i] == nil
            @campaignVoting << campaignVotes[i].campaign
          end

          respond_to do |format|
            format.js { render partial: 'campaignVotingDone' }
          end
        elsif current_user.isOnStep < 4
          if current_user.isOnStep < 3
            campaignVotes = current_user.campaignVotes.where(step: current_user.isOnStep)
          else
            campaignVotes = current_user.campaignVotes.where.not(voteType: 0)
          end

          @campaignVoting = []
          for i in 0..2
            next if campaignVotes[i] == nil
            @campaignVoting << campaignVotes[i].campaign
          end

          respond_to do |format|
            format.js { render partial: 'campaignVoting' }
          end
        else
          render :nothing => true
        end
      else
        render :nothing => true
    	end
  	end

  def page
    if params[:category].to_i > 0
      category = Category.find(params[:category])
      @campaigns = category.campaigns.order('(globalScore + roundScore) DESC')
    else
      @campaigns = Campaign.all.order('(globalScore + roundScore) DESC')
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
