# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.post_up_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/up', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', false)
			$('#'+button_id+'.post_up_vote').attr('disabled', true)
			$('#post_votes_' + button_id).html(data.message)
			return
		return

	$('.post_down_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/down', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', true)
			$('#'+button_id+'.post_up_vote').attr('disabled', false)
			$('#post_votes_' + button_id).html(data.message)
			return
		return

	$('.answer').click ->
		button_id = @id
		if $('#answer' + button_id).html() != ""
			$('#answer' + button_id).html("")
		else
			$('#answer' + button_id).load('/posts/answer/' + $('#data').data('topic') + '/' + button_id)
		return

	$('#more_posts').click ->
		page = $('#data').data('page') + 1
		interval = $('#data').data('interval')
		size = $('#data').data('size')
		topic = $('#data').data('topic')
		$($('<div class="posts">').load('/topics/' + topic + '/posts/page/' + page + '/' + interval)).insertAfter('.posts')
		$('#data').data('page', page)
		if page >= (Math.ceil(size/interval))
			$('#more_posts').hide()
		return