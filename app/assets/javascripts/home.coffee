# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#voting').slideUp 0
	$('.campaign-display').slideUp 0
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
	$('#start-voting').on 'click', ->
		$('#start-voting').hide()
		$('#back-voting').show()
		$('#voting').load "/vote/campaign/-1", (response, status) ->
			$('.campaign-display').slideUp(0)
			if $('#campaign').data('step') < 4
				$('#next-voting').show()
			else
				$('#next-voting').hide()
			return
		$('#voting').slideToggle()
		$('#campaigns-news').slideToggle()
		return
	$('#back-voting').on 'click', ->
		$('#start-voting').show()
		$('#back-voting').hide()
		$('#next-voting').hide()
		$('#voting').slideToggle()
		$('#campaigns-news').slideToggle()
		return
	$('body').on 'click', '.vote-star', ->
		$('.vote-star').children().removeClass('active')
		$(this).children().addClass('active')
		$('#campaign').data('vote', @id)
		return
	$('#next-voting').on 'click', ->
		campaign = $('#campaign').data('vote')
		$('#voting').load "/vote/campaign/" + campaign, (response, status) ->
			$('.campaign-display').slideUp(0)
			if $('#campaign').data('step') < 4
				$('#next-voting').show()
			else
				$('#next-voting').hide()
			return
		return
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