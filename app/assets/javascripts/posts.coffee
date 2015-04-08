# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('body').on 'click', '.post_up_vote', ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/up', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', false)
			$('#'+button_id+'.post_up_vote').attr('disabled', true)
			$('#post_votes_' + button_id).html(data.message)
			return
		return

	$('body').on 'click', '.post_down_vote', ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/down', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', true)
			$('#'+button_id+'.post_up_vote').attr('disabled', false)
			$('#post_votes_' + button_id).html(data.message)
			return
		return

	$('body').on 'click', '.answer', ->
		button_id = @id
		if $('#answer' + button_id).html() != ""
			$('#answer' + button_id).html("")
		else
			$('#answer' + button_id).load('/posts/answer/' + $('#data').data('campaign') + '/' + button_id)
		return

	$('body').on 'click', '#more_posts', ->
		page = $('#data').data('page') + 1
		interval = $('#data').data('interval')
		size = $('#data').data('size')
		campaign = $('#data').data('campaign')
		$($('<div class="posts">').load('/campaigns/' + campaign + '/posts/page/' + page + '/' + interval)).insertAfter('.posts')
		$('#data').data('page', page)
		if page >= (Math.ceil(size/interval))
			$('#more_posts').hide()
		return

	$('body').on 'click', '.more_comments', ->
		button_id = @id
		page = $('#' + button_id + '.data').data('page') + 1
		interval = $('#data').data('interval')
		size = $('#' + button_id + '.data').data('size')
		campaign = $('#data').data('campaign')
		$($('<div class="comments">').load('/posts/' + button_id + '/comments/page/' + page + '/' + interval)).insertBefore $(this).parent()
		$('#' + button_id + '.data').data 'page', page
		if page >= Math.ceil(size / interval)
			$(this).hide()
		return

	$('body').on 'click', '.cancel', ->
		$('.answer_div').html("")
		return