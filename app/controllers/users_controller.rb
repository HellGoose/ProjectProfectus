class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update]
	helper_method :getFacebookPicURL

	def show
	end

	def edit
		if !current_user || !is_this_user
			redirect_to user_path(params[:id])
		end
	end

	def update
		respond_to do |format|
			if current_user && is_this_user && @user.update(user_params)
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
			format.html { redirect_to '/signout', notice: 'User was deleted.' }
			format.json { head :no_content }
		end
	end

  def getFacebookPicURL
    'http://graph.facebook.com/' + @user.uid + '/picture?type=large'
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
