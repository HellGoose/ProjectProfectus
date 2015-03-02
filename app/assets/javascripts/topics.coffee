# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.up_vote').click ->
    button_id = @id
    $.post '/vote/topic/' + button_id + '/up', (data, status) ->
      $('.up_vote').attr('disabled', true)
      $('.down_vote').attr('disabled', false)
      voteNum = document.getElementById('votes#' + button_id)
      voteNum.innerHTML = parseInt(voteNum.innerHTML) + 1
      return
    return

  $('.down_vote').click ->
    button_id = @id
    $.post '/vote/topic/' + button_id + '/down', (data, status) ->
      $('.down_vote').attr('disabled', true)
      $('.up_vote').attr('disabled', false)
      voteNum = document.getElementById('votes#' + button_id)
      voteNum.innerHTML = parseInt(voteNum.innerHTML) - 1
      return
    return
