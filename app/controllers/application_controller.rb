class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	helper_method :current_user, :isAdmin, :getFacebookPicURL
	
	# Public: Makes the current user globally accessible.
	#
	# @current_user - Contains the current logged in user. Is nil if the user haven't logged in.
	#
	# Returns the current user.
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	# Public: Checks if the current user is an admin.
	#
	# Returns true iff current user is an admin.
	def isAdmin
		if current_user != nil
			current_user.role > 1
		else
			false
		end
	end

	# Public: Gets the users facebook profile picture.
	#
	# Returns the profile picture.
	def getFacebookPicURL(user)
		'http://graph.facebook.com/' + user.uid + '/picture?type=large'
	end
end