class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update, :campaignPage]
	helper_method :getFacebookPicURL

	def show
		@userCampaigns = @user.campaigns.order('(globalScore + roundScore) DESC')
		@campaignsInterval = 8
	end

	def edit
		if !current_user || !is_this_user
			redirect_to user_path(params[:id])
		end
	end

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

	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to '/signout', notice: '<span class="alert alert-success">User was deleted.</span>' }
			format.json { head :no_content }
		end
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:username, :email, :image, :location, :address, :phone)
		end

		def is_this_user
			@user.id == current_user.id
		end
end