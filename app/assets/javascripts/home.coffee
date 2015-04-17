# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#voting').slideUp 0
	$('.campaign-display').slideUp 0
	$('.campaign-vote').on 'click', ->
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
		$('#voting').slideToggle()
		$('#tabs').slideToggle()
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