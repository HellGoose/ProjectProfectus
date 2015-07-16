# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Runs the code after the document is ready
$(document).ready ->
	# Slides up the voting div
	$('#voting').slideUp 0

	# Slides up the campaign-display div.
	$('.campaign-display').slideUp 0

	# Slides down the preview of the current campaign and slides up
	# the others.
	$('body').on 'click', '.campaign-vote', ->
		if @id == '0'
			$('#0.campaign-display').slideToggle()
			$('#1.campaign-display').slideUp(0)
			$('#2.campaign-display').slideUp(0)
		if @id == '1'
			$('#1.campaign-display').slideToggle()
			$('#0.campaign-display').slideUp(0)
			$('#2.campaign-display').slideUp(0)
		if @id == '2'
			$('#2.campaign-display').slideToggle()
			$('#1.campaign-display').slideUp(0)
			$('#0.campaign-display').slideUp(0)
		return

	# Loads the voting div when the user clicks on the Make a Difference
	# button. Also slides up the news, the top 8 campaigns and
	# replaces the Make a Difference button with a back and a next button.
	$('#start-voting').on 'click', ->
		$('#start-voting').hide()
		$('#back-voting').show()
		$('#voting').load "/vote/campaign/-1", (response, status) ->
			$('.campaign-display').slideUp(0)
			if $('#campaign').data('step') < 4
				$('#next-voting').show()
			else
				$('#next-voting').hide()
			$('#voting').slideToggle()
			$('#campaigns-news').slideToggle()
			return
		return

	# Hides the back button, next button and displays the Make a Difference
	# button when the user clicks on the back button.
	# Also slides down news, top 8 campaigns and slides up the voting div.
	$('#back-voting').on 'click', ->
		$('#start-voting').show()
		$('#back-voting').hide()
		$('#next-voting').hide()
		$('#voting').slideToggle()
		$('#campaigns-news').slideToggle()
		return

	# Sets the custom data value vote to the current selected star,
	# sets the star to active and removes the active class 
	# from the other stars.
	$('body').on 'click', '.vote-star', ->
		$('.vote-star').children().removeClass('active')
		$(this).children().addClass('active')
		$('#campaign').data('vote', @id)
		return

	# Loads the next voting set of campaigns when the user clicks on the
	# vote button. Also sends the list id of the current voted campaign.
	$('#next-voting').on 'click', ->
		campaign = $('#campaign').data('vote')
		$('#campaign').data('vote', -1)
		$('#voting').load "/vote/campaign/" + campaign, (response, status) ->
			$('.campaign-display').slideUp(0)
			if $('#campaign').data('step') < 4
				$('#next-voting').show()
			else
				$('#next-voting').hide()
			return
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
	return
