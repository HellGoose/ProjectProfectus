# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	data = document.getElementById('data')
	topic = data.getAttribute('data-topic')

	$('.post_up_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/up', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', false)
			$('#'+button_id+'.post_up_vote').attr('disabled', true)
			voteNum = document.getElementById('post_votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) + 1
			return
		return

	$('.post_down_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/down', (data, status) ->
			$('#'+button_id+'.post_down_vote').attr('disabled', true)
			$('#'+button_id+'.post_up_vote').attr('disabled', false)
			voteNum = document.getElementById('post_votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) - 1
			return
		return

	$('.answer').click ->
		button_id = @id
		$('#answer' + button_id).load('/posts/answer/' + topic + '/' + button_id)
		return