# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('.post_up_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/up', (data, status) ->
			voteNum = document.getElementById('votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) + 1
			return
		return

	$('.post_down_vote').click ->
		button_id = @id
		$.post '/vote/post/' + button_id + '/down', (data, status) ->
			voteNum = document.getElementById('votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) - 1
			return
		return