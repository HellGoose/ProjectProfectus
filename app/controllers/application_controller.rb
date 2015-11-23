class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	helper_method :current_user, :isAdmin, :getFacebookPicURL, :current_round, :get_notifications
	
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

	# Public: Gets the users profile picture.
	#
	# Returns the profile picture.
	def getPic(user)
		if !user.image || user.image == ''
			'http://graph.facebook.com/' + user.uid + '/picture?type=large'
		else
			user.image
		end
	end

	def get_notifications
		if !current_user
			return nil
		end
		round = Round.first
		notifications = current_user
				.notifications
				.where(created_at: Time.at(round.endTime.to_i - round.duration * 2)
				.to_datetime..Time.now)
				.order('created_at DESC')
		return notifications
	end

	def current_round
		Round.maximum(:currentRound)
	end

	def send_notification(points, notification, link, icon, popup)
		notification = Notification.new(notification: notification, points: points, link: link, icon: icon, popup: popup)
		current_user.notifications << notification
		current_user.save
	end

	def send_notification_user(user, points, notification, link, icon, popup)
		notification = Notification.new(notification: notification, points: points, link: link, icon: icon, popup: popup)
		user.notifications << notification
		user.save
	end

	# printable ASCII chars (between 32 and 126) without 0..9, A..Z, a..z
	def symbols
		' !"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~' # symbols.length === 33
	end
	
	def gsub(input, replace)
		search = Regexp.new(replace.keys.map{|x| "(?:#{Regexp.quote(x)})"}.join('|'))
		input.gsub(search, replace)
	end

	# same as the JavaScript encodeURI
	def encodeURI(value)
		# encodeURI(symbols)  === "%20   ! %22   #   $ %25   &   '   (   )   *   +   , - .   /   :   ; %3C   = %3E   ?   @ %5B %5C %5D %5E _ %60 %7B %7C %7D   ~"
		# CGI.escape(symbols) === "  + %21 %22 %23 %24 %25 %26 %27 %28 %29 %2A %2B %2C - . %2F %3A %3B %3C %3D %3E %3F %40 %5B %5C %5D %5E _ %60 %7B %7C %7D %7E"
		gsub(CGI.escape(value.to_s),
				'+'   => '%20',  '%21' => '!',  '%23' => '#',  '%24' => '$',  '%26' => '&',  '%27' => "'",
				'%28' => '(',    '%29' => ')',  '%2A' => '*',  '%2B' => '+',  '%2C' => ',',  '%2F' => '/',
				'%3A' => ':',    '%3B' => ';',  '%3D' => '=',  '%3F' => '?',  '%40' => '@',  '%7E' => '~'
		)
	end

	# same as the JavaScript encodeURIComponent, also for UTF8 multibyte chars (including gclef)
	def encodeURIComponent(value)
		# encodeURIComponent(symbols) === "%20   ! %22 %23 %24 %25 %26   '   (   )   * %2B %2C - . %2F %3A %3B %3C %3D %3E %3F %40 %5B %5C %5D %5E _ %60 %7B %7C %7D   ~"
		# CGI.escape(symbols)         === "  + %21 %22 %23 %24 %25 %26 %27 %28 %29 %2A %2B %2C - . %2F %3A %3B %3C %3D %3E %3F %40 %5B %5C %5D %5E _ %60 %7B %7C %7D %7E"
		gsub(CGI.escape(value.to_s),
				'+'   => '%20',  '%21' => '!',  '%27' => "'",  '%28' => '(',  '%29' => ')',  '%2A' => '*',
				'%7E' => '~'
		)
	end

	# same as the JavaScript decodeURI
	def decodeURI(value)
		# decodeURI(encodeURI(symbols))     === symbols
		# CGI.unescape(CGI.escape(symbols)) === symbols
		CGI.unescape(gsub(value.to_s,
				'%20' => '+',    '!' => '%21',  '#' => '%23',  '$' => '%24',  '&' => '%26',  "'" => '%27',
				'('   => '%28',  ')' => '%29',  '*' => '%2A',  '+' => '%2B',  ',' => '%2C',  '/' => '%2F',
				':'   => '%3A',  ';' => '%3B',  '=' => '%3D',  '?' => '%3F',  '@' => '%40',  '~' => '%7E'
		))
	end

	# same as the JavaScript decodeURIComponent
	def decodeURIComponent(value)
		# decodeURIComponent(encodeURIComponent(symbols)) === symbols
		# CGI.unescape(CGI.escape(symbols))               === symbols
		CGI.unescape(gsub(value.to_s,
			'%20' => '+',    '!' => '%21',  "'" => '%27',  '(' => '%28',  ')' => '%29',  '*' => '%2A',
			'~'   => '%7E'
		))
	end

	def currentUserCanUseAbility(ability_id)
		currentUserHasAbility && currentUsersHasChargesLeftOnAbility
	end

	def currentUserHasAbility(ability_id)
		Ability.find(ability_id).reqLevel <= current_user.level
	end

	def currentUsersHasChargesLeftOnAbility(ability_id)
		current_user.abilities.find_by(ability_id: ability_id).charges > 0 or false
	end
end
