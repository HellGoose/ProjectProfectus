# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Runs the code after the document is ready
$(document).ready ->
	# Slides up the form for news creation
	$('#news_form').slideToggle 0

	# Slides down the form for news creation when the user clicks
	# the Post News button
	$('#post_news').click ->
		$('#news_form').slideToggle()
		return

	# Loads more news when the user clicks the Show More button.
	# The code sends a GET request to the webserver and the controller
	# returns the correct news to be displayed. The data returned is 
	# dynamically added below the current news list.
	$('#more_news').click ->
		page = $('#news').data('page') + 1
		interval = $('#news').data('interval')
		size = $('#news').data('size')
		$($('<div class="news_container">').load('/news/page/' + page + '/' + interval)).insertAfter('.news_container')
		$('#news').data('page', page)
		if page >= (Math.ceil(size/interval))
			$('#more_news').hide()
		return

	# Updates the duration for the Round. 
	# Sends a POST request with the given duration 
	# and receives a feedback message
	$('#update-duration').on 'click', ->
		days = $('#days').val()
		hours = $('#hours').val()
		days_in_seconds = 0
		hours_in_seconds = 0
		if (isNaN(days) or parseInt(days) < 0) or (isNaN(hours) or parseInt(hours) < 0) or (days == '' and hours == '')
			$('#days').val('')
			$('#hours').val('')
			display_notification('<h3>Invalid input. Only positive numbers.</h3>')
		else
			if (days == '')
				days_in_seconds = 0
			else
				days_in_seconds = (parseInt(days))*86400
			if (hours == '')
				hours_in_seconds = 0
			else
				hours_in_seconds = (parseInt(hours))*3600
			
			duration = days_in_seconds+hours_in_seconds
			$.post '/admin/round/update/'+duration.toString(), (data, status) ->
				$('#days').val('')
				$('#hours').val('')
				display_notification('<h3>' + data.message + '</h3>')
				return
		return

	# Forces the script to run a new Round.
	# Sends a POST request and recieves a feedback message.
	$('#force-new-round').on 'click', ->
		$.post '/admin/round/force/true', (data, status) ->
			display_notification('<h3>' + data.message + '</h3>')
			return
		return

	$('body').on 'click', '.clear_button', ->
		$('#flagged_projects-tab').load '/admin/clear_campaign/' + @id
		return

	$('body').on 'click', '.delete_button', ->
		$('#flagged_projects-tab').load '/admin/delete_campaign/' + @id
		return
	return
