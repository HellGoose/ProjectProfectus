class SessionsController < ApplicationController
	# Public: Sets the user_id.
	# Route: GET root/auth/:provider/callback
	# 	:provider - The provider used to log in.
	#
	# user 		- The user who logged in.
	# session - The session containing the session variables.
	#
	# Renders root.
	def create
		auth_params = request.env['omniauth.auth']
		params = request.env['omniauth.params']

		user_tmp = User.find_by(uid: auth_params['uid'])
		user = User.from_omniauth(auth_params)
		referer = User.find_by(id: params['referer'].to_i)

		if user_tmp == nil && user.uid != referer.uid && referer != nil
			referer.points += 5
			referer.save
		end

		if !user.hasLoggedInThisRound
			user.points += 1
			user.hasLoggedInThisRound = true
			user.save
		end
		
		session[:user_id] = user.id
		session[:return_to] ||= request.referer
		redirect_to root_path
	end

	# Public: Resets the user_id.
	# Route: DELETE root/signout
	#
	# session - The session containing the session variables.
	#
	# Renders root
	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end