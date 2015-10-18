# Place all the behaviors and hooks related to the matching controller here.

# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Runs the code after the document is ready
$(document).ready ->
	page = $('#data').data('page')
	size = $('#data').data('size')
	interval = $('#data').data('interval')

	# Initially disables button if there are no more users on the next
	# page or the user is on page 0
	if page == 0
		$('#prev').attr('disabled', true)
	if size <= interval
		$('#next').attr('disabled', true)

	# Changes pages when the user clicks on the next and previous buttons.
	$('#next').click ->
		changePage('>')
		return
	$('#prev').click ->
		changePage('<')
		return

	# Changes pages when the user uses the arrow keys.
	window.onkeyup = (e) ->
		key = if e.keyCode then e.keyCode else e.which
		switch key
			when 39
				$('#next').click()
			when 37
				$('#prev').click()
			else
				break
		return
	return

# Changes pages for the leaderboard.
# Valid inputs are '>', '<' and 'reset'. 
# '>' changes to the next page. '<' changes to the previous page.
# 'Reset' basically goes to the first page of the current list.
# For the user loading a GET request is sent to the webserver
# and the controller returns the correct list based on the page. 
# The list is then dynamically replacing the current list.
changePage = (dir) ->
	page = $('#data').data('page')
	size = $('#data').data('size')
	interval = $('#data').data('interval')

	if (dir == '>')
		if page < (Math.ceil(size/interval) - 1)
			page += 1
			$('#prev').attr('disabled', false)
			if page == Math.ceil(size/interval) - 1
				$('#next').attr('disabled', true)
		else
			$('#next').attr('disabled', true)
	else if (dir == '<')
		if page > 0
			page -= 1
			$('#next').attr('disabled', false)
			if page == 0
				$('#prev').attr('disabled', true)
		else
			if page <= 0
				$('#prev').attr('disabled', true)
			else
				$('#prev').attr('disabled', false)
			if size > interval
				$('#next').attr('disabled', false)
	else
		page = 0

	$('#leaderboard').load '/leaderboard/' + page + '/' + interval, (data, response) ->
		$('#data').data('page', page)
		return
	return
