class SessionsController < ApplicationController
	helper_method :getFacebookPicURL, :getPic

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

		if !user_tmp && user
			send_notification_user(user, 25, 'You logged in for the first time!', '', '', true)
			user.hasLoggedInThisRound = true
			user.save
		elsif !user.hasLoggedInThisRound
			send_notification_user(user, 1, 'You logged in this round!', '', '', true)
			user.points += 1
			user.hasLoggedInThisRound = true
			user.save
		end

		if user_tmp == nil && referer != nil && user.uid != referer.uid 
			send_notification_user(referer, 5, 'You refered ' + user.name + '!', '', '', true)
			referer.points += 5
			referer.save
		end
		
		session[:user_id] = user.id
		session[:return_to] ||= request.referer

		if (params['mobile'].to_i == 1)
			redirect_to '/mobile/login/'
		else
			redirect_to root_path
		end
	end

	def mobile_login
		render partial: 'mobile/login', layout: 'windowed'
	end

	# Public: Resets the user_id.
	# Route: DELETE root/signout
	#
	# session - The session containing the session variables.
	#
	# Renders root
	def destroy
		session[:user_id] = nil
		if (params['mobile'].to_i == 1)
			redirect_to '/mobile/login/'
		else
			redirect_to root_path
		end
	end
end