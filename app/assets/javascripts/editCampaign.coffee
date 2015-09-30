$(document).ready ->
	$('#campaign_link').attr('disabled', true)
	$('#campaign-image').attr('src', $('#image-field').val())
	$('#campaign-title').html($('#title-field').val())
	$('#campaign-description').html($('#description-field').val())
	$('#submitButton').val('Update')
	$('#submitButton').attr('disabled', false)
	return