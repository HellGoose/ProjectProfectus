# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.up_vote').click ->
    button_id = @id
    $.post '/vote/topic/' + button_id + '/up', (data, status) ->
      $('#'+button_id+'.down_vote').attr('disabled', false)
      $('#'+button_id+'.up_vote').attr('disabled', true)
      $('#votes_' + button_id).html(data.message)
      return
    return

  $('.down_vote').click ->
    button_id = @id
    $.post '/vote/topic/' + button_id + '/down', (data, status) ->
      $('#'+button_id+'.down_vote').attr('disabled', true)
      $('#'+button_id+'.up_vote').attr('disabled', false)
      $('#votes_' + button_id).html(data.message)
      return
    return
