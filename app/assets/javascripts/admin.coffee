# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#news_form').slideToggle 0
	$('#post_news').click ->
		$('#news_form').slideToggle()
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
	$('#update-duration').on 'click', ->
		days_in_seconds = 0
		hours_in_seconds = 0
		if $('#days').val() != ''
			days_in_seconds = (parseInt $('#days').val())*86400
		if $('#hours').val() != ''
			hours_in_seconds = (parseInt $('#hours').val())*3600
		duration = days_in_seconds+hours_in_seconds
		$.post '/admin/round/update/'+duration.toString(), (data, status) ->
			$('#days').val('')
			$('#hours').val('')
			$('#feedback').html(data.message)
			return
		return
	$('#force-new-round').on 'click', ->
		$.post '/admin/round/force/true', (data, status) ->
			return
		return
	return