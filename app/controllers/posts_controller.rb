class PostsController < ApplicationController
	before_action :set_post, only: [:edit, :update, :destroy]

	# Public: Gets the comments of a post.
	# Route: GET root/posts/:id/comments/page/:page/:interval
	# 	:id 			- The id of the post in the database
	# 	:page 		- The current comment page to be shown.
	# 	:interval - Number of comments per page.
	#
	# comments - All the comments related to the post.
	# page 		 - The current page to be shown.
	# interval - Number of comments before the "show more" button.
	#
	# Renders all the comments of a post.
	def commentPage
		comments = Post.find(params[:id]).comments.order("voteCount DESC")
		page = params[:page]
		interval = params[:interval]
		respond_to do |format|
			format.js { render partial: "posts/comments", locals: { page: page, postsPerPage: interval, comments: comments } }
		end
	end

	# Public: Gets the posts of a campaign.
	# Route: GET root/campaigns/:id/posts/page/:page/:interval
	# 	:id 			- The id of the campaign in the database
	# 	:page 		- The current post page to be shown.
	# 	:interval - Number of posts per page.
	#
	# comments - All the posts related to the campaign.
	# page 		 - The current page to be shown.
	# interval - Number of cposts before the "show more" button.
	#
	# Renders all the posts of a campaign.
	def page
		@posts = Campaign.find(params[:id]).posts.where("isComment = 0").order("voteCount DESC")
		page = params[:page]
		interval = params[:interval]
		respond_to do |format|
			format.js { render partial: "posts", locals: { page: page, postsPerPage: interval } }
		end
	end

	# Public: Prepares variables for a "new comment" form.
	# Route: GET root/posts/answer/:campaign_id/:post_id
	# 	:camapign_id - The id of the campaign in the database.
	# 	:post_id 		 - The id of the post in the database.
	#
	# @post 		- Placeholder for the "new comment" form.
	# @campaign - The campaign the comment belongs to.
	# @op 			- The post the comment belongs to.
	#
	# Renders the "new comment" form.
	def answer
		if !current_user
			redirect_to '/'
			return
		end
		@post = Post.new
		@campaign = Campaign.find(params[:campaign_id])
		@op = Post.find(params[:post_id])
		respond_to do |format|
			format.js { render partial: "posts/postForm" }
		end
	end

	# Public: Process vote requests for posts.
	# Route: GET root/vote/post/:id/:dir
	# 	:id  - The id of the post in the database.
	# 	:dir - The direction of the vote (Up or Down)
	#
	# post - The post to be voted.
	# userVote - Contains the actual vote.
	#
	# Renders the updated voting score.
	def vote
		if current_user
			post = Post.find(params[:id])
			userVote = post.votes.find_by(user_id: session[:user_id])
			if (userVote == nil)
				userVote = post.votes.create(post_id: post.id, user_id: session[:user_id])
				if params[:dir] == "up"
					post.voteCount += 1
				elsif params[:dir] == "down"
					post.voteCount -= 1
				end				
			else
				if params[:dir] == "up" and userVote.isDownvote != false
					userVote.isDownvote = false
					post.voteCount += 2
				elsif params[:dir] == "down" and userVote.isDownvote != true
					userVote.isDownvote = true
					post.voteCount -= 2
				end
			end
			userVote.save()
			post.save()
			respond_to do |format|
				msg = { status: "ok", message: post.voteCount }
				format.json { render json: msg }
			end
		end
	end

	# Public: Prepares variables for a "new post" form.
	# Route: GET root/posts/answer/:campaign_id/:post_id
	# 	:camapign_id - The id of the campaign in the database.
	# 	:post_id 		 - The id of the post in the database.
	#
	# @post 		- Placeholder for the "new post" form.
	# @op 			- The post the post belongs to. (nil)
	#
	# Renders the "new post" form.
	def new
		if !current_user
			redirect_to '/'
			return
		end
		@post = Post.new
		@op = nil
	end

	# Public: Prepares variables for post#edit.
	# Route: GET root/post/:id/edit
	# 	:id - The id of the post in the database.
	#
	# Renders post#edit iff current user is post owner or admin, 
	# otherwise redirects to related campaign page.
	def edit
		if !isPostOwner && !isAdmin
			redirect_to Campaign.find(@post.campaign_id)
		end
	end

	# Public: Creates a new post.
	# Route: POST root/posts/
	#
	# @post 			- The post to be added in the database.
	# @campaign 	- The campaign the post belongs to.
	#
	# Renders campaign#show iff the creaton succeeds,
	# otherwise renders campaign#show with the error.
	def create
		if current_user
			@post = Post.new(content: post_params[:content], campaign_id: post_params[:campaign_id])
			@post.user_id = session[:user_id]
			@campaign = Campaign.find(@post.campaign_id)

			if (post_params[:post_id] != nil)
				@op = Post.find(post_params[:post_id])
				@op.comments << @post
				@op.save
				@post.isComment = true
			end

			respond_to do |format|
				if @post.save
					current_user.points +=3
					current_user.save
					@campaign.save
					format.html { redirect_to @campaign }
				else
					format.html { redirect_to @campaign }
					format.json { render json: @post.errors, status: :unprocessable_entity }
				end
			end
		end
	end

	# Public: Updates a post iff the current user is the post owner or an admin.
	# Route: PUT root/posts/:id
	# 	:id - The id of the post in the database.
	#
	# @post 	 - The post to be updated.
	# campaign - The campaign the post belongs to.
	#
	# Renders campaign#show iff the update succeeds, 
	# otherwise rerenders post#edit with the error.
	def update
		if !current_user
			redirect_to '/'
			return
		end
		campaign = Campaign.find(@post.campaign_id)
		respond_to do |format|
			if (isPostOwner || isAdmin) && @post.update(post_params)
				msg = "<span class=\"alert alert-success\">Post was successfully updated.</span>"
				format.html { redirect_to campaign, notice: msg }
				format.json { render :show, status: :ok, location: @post }
			else
				format.html { render :edit }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	# Public: Deletes a post from the database.
	# Route: DELETE root/posts/:id
	# 	:id - The id of the post in the database.
	#
	# @post 	 - The post to be updated.
	# campaign - The campaign the post belongs to.
	#
	# Renders campaign#show iff the deletion succeeded,
	# otherwise renders campaign#show with the error.
	def destroy
		if !current_user
			redirect_to '/'
			return
		end
		campaign = Campaign.find(@post.campaign_id)
		respond_to do |format|
			if isPostOwner && @post.destroy
				msg = "<span class=\"alert alert-success\">Post was successfully destroyed.</span>"
				format.html { redirect_to campaign, notice: msg }
				format.json { head :no_content }
			else
				msg = "<span class=\"alert alert-warning\">You cannot delete this post.</span>"
				format.html { redirect_to campaign, notice: msg }
				format.json { head :no_content }
			end
		end
	end

	private

	# Private: Makes the a post globally accessible.
	#
	# @post - The globally accessible post.
	#
	# Returns the post.
	def set_post
		@post = Post.find(params[:id])
	end

	# Private: Checks if the fields of the given parameters are allowed.
	#
	# params - The parameters to check.
	#
	# Returns the parameters iff the parameters are allowed.
	def post_params
		params.require(:post).permit(:content, :campaign_id, :post_id)
	end

	# Private: Checks if the current user owns the given post.
	#
	# @post - The given post.
	#
	# Returns true if the current user is the owner.
	def isPostOwner
		@post.user_id == session[:user_id]
	end
end
