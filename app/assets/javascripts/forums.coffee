# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	forum = parseInt(data.getAttribute('data-forum'))
	buttonUp = document.getElementsByClassName('up_vote')
	buttonDown = document.getElementsByClassName('down_vote')

	$('.up_vote').click ->
		button_id = @id
		$.post '/forum/' + forum + '/' + button_id + '/up', (data, status) ->
			voteNum = document.getElementById('votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) + 1
			return
		return

	$('.down_vote').click ->
		button_id = @id
		$.post '/forum/' + forum + '/' + button_id + '/down', (data, status) ->
			voteNum = document.getElementById('votes#' + button_id)
			voteNum.innerHTML = parseInt(voteNum.innerHTML) - 1
			return
		return