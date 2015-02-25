# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	forum = parseInt(data.getAttribute('data-forum'))
	buttonUp = document.getElementsByClassName('up_vote')
	buttonDown = document.getElementsByClassName('down_vote')

	i = 0
	while i < buttonUp.length
		button = buttonUp[i]
		$(button).click ->
			$.post '/forum/' + forum + '/' + button.id + '/up', (data, status) ->
				voteNum = document.getElementById('votes#' + button.id)
				voteNum.innerHTML = parseInt(voteNum.innerHTML) + 1
				return
			return
		i++
	i = 0
	while i < buttonDown.length
		button = buttonDown[i]
		$(button).click ->
			$.post '/forum/' + forum + '/' + button.id + '/down', (data, status) ->
				voteNum = document.getElementById('votes#' + button.id)
				voteNum.innerHTML = parseInt(voteNum.innerHTML) - 1
				return
			return
		i++
	return