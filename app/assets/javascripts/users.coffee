# Place all the behaviors and hooks related to the matching controller here.

# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Runs the code after the document is ready
$(document).ready ->
	# Loads more campaigns when the user clicks on the Show More button.
	# The code sends a GET request to the webserver and the controller
	# returns the correct campaigns to be displayed. The data returned is 
	# dynamically added below the current campaign list.
	$('body').on 'click', '#more_campaigns', ->
		page = $('#data').data('page') + 1
		interval = $('#data').data('interval')
		size = $('#data').data('size')
		$($('<div class="user-campaigns2">').load(window.location.pathname + '/campaigns/' + page + '/' + interval)).insertAfter('.user-campaigns2')
		$('#data').data('page', page)
		if page >= (Math.ceil(size/interval))
			$('#more_campaigns').hide()
		return