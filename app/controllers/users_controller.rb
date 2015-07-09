class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :campaignPage]
	helper_method :getFacebookPicURL

	# Public: Prepares variables for user#show.
	# Route: GET root/users/:id
	# 	:id - The id of the user in the database.
	#
	# @userCampaigns 		 - All campaigns belonging to the user.
	# @campaignsInterval - Number of campaigns shown per page.
	#
	# Renders user#show.
	def show
		@userCampaigns = @user.campaigns.order('(globalScore + roundScore) DESC')
		@campaignsInterval = 8
	end

	# Public: Prepares variables for user#edit.
	# Route: GET root/users/:id/edit
	# 	:id - The id of the user in the database.
	#
	# Renders user#edit.
	def edit
		if !current_user || !is_this_user
			redirect_to user_path(params[:id])
		end
	end

	# Public: Gets the campaigns of a user.
	# Route: GET /users/:id/campaigns/:page/:interval
	# 	:id 			- The id of the user in the database
	# 	:page 		- The current campaign page to be shown.
	# 	:interval - Number of campaigns per page.
	#
	# page 		 			 - The current page to be shown.
	# interval 			 - Number of campaigns before the "show more" button.
	# @userCampaigns - The campaigns to be shown.
	#
	# Renders all the campaigns contained in @userCampaign.
	def campaignPage
		page = params[:page].to_i
 		interval = params[:interval].to_i
 		if (page * interval <= @user.campaigns.size)
 			@userCampaigns = @user.campaigns.order('(globalScore + roundScore) DESC').first(page * interval).last(interval)
 		else
 			@userCampaigns = @user.campaigns.order('(globalScore + roundScore) DESC').last(@user.campaigns.size % interval)
 		end
 		respond_to do |format|
    	format.js { render partial: 'userCampaigns' }
    end
	end

	# Public: Updates a user if the current user is this user.
	# Route: PUT root/users/:id
	# 	:id - The id of the user in the database.
	#
	# @user - The user to update.
	#
	# Renders user#show if the update succeeds, 
	# otherwise rerenders user#edit with the error.
	def update
		respond_to do |format|
			if current_user && is_this_user && @user.update(user_params)
				format.html { redirect_to @user, notice: '<span class="alert alert-success">User was successfully updated.</span>' }
				format.json { render :show, status: :ok, location: @user }
			else
				format.html { render :edit }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# Public: Redirects signup with referer to facebook login.
	# Route: GET /signup/:referer
	# 	:referer - The id of the user that refererd this user.
	#
	# Redirects to session#create.
	def referer
		#referer = User.find_by(id: params[:referer].to_i)
		redirect_to '/auth/facebook?referer=' + params[:referer]
	end

	# Public: Deletes a user from the database.
	# Route: DELETE root/users/:id
	# 	:id - The id of the user in the database.
	#
	# @user - The user to be deleted.
	#
	# Redirects to session#destroy.
	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to '/signout', notice: '<span class="alert alert-success">User was deleted.</span>' }
			format.json { head :no_content }
		end
	end

	private
	
	# Private: Makes the a user globally accessible.
	#
	# @user - The globally accessible user.
	#
	# Returns the user.
	def set_user
		@user = User.find(params[:id])
	end

	# Private: Checks if the fields of the given parameters are allowed.
	#
	# params - The parameters to check.
	#
	# Returns the parameters iff the parameters are allowed.
	def user_params
		params.require(:user).permit(:username, :email, :image, :location, :address, :phone)
	end

	# Private: Checks if the current user is the given user.
	#
	# @user - The given user.
	#
	# Returns true if the current user is the given user.
	def is_this_user
		@user.id == current_user.id
	end
end