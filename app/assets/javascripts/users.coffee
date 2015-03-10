# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#addMoney').click ->
		amount = $('#addMoneyAmount').val()
		$.post document.URL + '/addMoney/' + amount ,(data, status) ->
			$('#money').html(data.message)
			return
		return
	return
return