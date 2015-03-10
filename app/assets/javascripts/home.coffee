# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#donate').click ->
		$.post '/donate/5', (data, status) ->
			$('#donationAmount').html(data.message)
			return
		return
	return