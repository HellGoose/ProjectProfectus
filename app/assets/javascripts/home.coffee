# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Runs the code after the document is ready
$(document).ready ->
	# Slides up the voting div
	$('#voting').hide()

	# Slides up the campaign-display div.
	$('.campaign-display').hide()

	# Load voting at once, to prevent lag on start-voting (although lags front page a little)
	$('#voting').load("/vote/campaign/-1")


	# Slides down the preview of the current campaign and slides up
	# the others.
	$('body').on 'click', '.campaign-vote', ->
		if @id == '0'
			$('#1.campaign-display').fadeOut(100)
			$('#2.campaign-display').fadeOut(100)
			$('#0.campaign-display').fadeToggle()
		if @id == '1'
			$('#0.campaign-display').fadeOut(100)
			$('#2.campaign-display').fadeOut(100)
			$('#1.campaign-display').fadeToggle()
		if @id == '2'
			$('#1.campaign-display').fadeOut(100)
			$('#0.campaign-display').fadeOut(100)
			$('#2.campaign-display').fadeToggle()
		return

	# Loads the voting div when the user clicks on the Make a Difference
	# button. Also slides up the news, the top 8 campaigns and
	# replaces the Make a Difference button with a back and a next button.
	$('#start-voting').on 'click', ->
		$('.campaign-display').hide()
		$('#voting').slideDown(400)
		$('.start-voting-row').fadeOut()
		$('#campaigns-news').fadeOut()
		return

	# Hides the back button, next button and displays the Make a Difference
	# button when the user clicks on the back button.
	# Also slides down news, top 8 campaigns and slides up the voting div.
	$('body').on 'click', '#back-voting-small', ->
		$('.campaign-display').hide()
		$('#voting').slideUp(400)
		$('.start-voting-row').delay(100).fadeIn()
		$('#campaigns-news').delay(100).fadeIn()
		$('.campaign-box').each ->
  		$(this).removeClass 'down-arrow'
  		return
		return

	# Sets the custom data value vote to the current selected star,
	# sets the star to active and removes the active class 
	# from the other stars.
	$('body').on 'click', '.vote-star-button', ->
		$('.vote-star').children().removeClass('active')
		$(this).addClass('active')
		$('#campaign').data('vote', parseInt(@id.slice(-1)))
		return

	# Refreshes for 3 new campaigns for voting when the user clicks on the
	# refresh button. Does not change the step.
	$('#refresh-voting').on 'click', ->
		$('#voting').load "/refresh/campaigns/", (response, status) ->
			$('.campaign-display').slideUp()
		return

	$('body').on 'click', '#refresh-voting-small', ->
		$('#voting').load "/refresh/campaigns/", (response, status) ->
			$('.campaign-display').slideUp()
		return

	# Loads the next voting set of campaigns when the user clicks on the
	# vote button. Also sends the list id of the current voted campaign.
	$('#next-voting').on 'click', ->
		campaign = $('#campaign').data('vote')
		$('#campaign').data('vote', -1)
		$('#voting').load "/vote/campaign/" + campaign, (response, status) ->
			$('.campaign-display').slideUp()
			if $('#campaign').data('step') < 4
				$('#next-voting').show()
			else
				$('#next-voting').hide()
			if $('#campaign').data('step') < 3
				$('#refresh-voting').show()
			else
				$('#refresh-voting').hide()
			return
		return

	# Loads the next voting set of campaigns when the user clicks on the
	# vote button. Also sends the list id of the current voted campaign.
	$('body').on 'click', '.continue-button', (event) ->
		event.stopPropagation()
		campaign = $('#campaign').data('vote')
		$('#campaign').data('vote', -1)
		$('#voting').load "/vote/campaign/" + campaign, (response, status) ->
			$('.campaign-display').hide()
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
