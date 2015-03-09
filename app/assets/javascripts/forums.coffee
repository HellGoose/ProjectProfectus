# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


nextPage = ->
  page = $('#data').data('page') + 1
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  if (page > Math.ceil(size / interval))
    page = Math.ceil(size / interval)
  $('#topics').load('/topics/' + $('#data').data('forum') + '/page/' + page + '/' + interval)
  $('#data').data('page', page)
  return

prevPage = ->
  page = $('#data').data('page') - 1
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  if page < 1
    page = 1
  $('#topics').load('/topics/' + $('#data').data('forum') + '/page/' + page + '/' + interval)
  $('#data').data('page', page)
  return

$(document).ready ->
  $('#menu').prepend('<li><a href="/projects/new">New Project</a></li>')
  $('#voteButton').click ->
    $.post document.URL + '/vote', (data, status) ->
      if $('#voteButton').html() == 'Vote'
        $('#voteButton').html('Unvote')
        $('#votes').html(data.message)
      else
        $('#voteButton').html('Vote')
        $('#votes').html(data.message)
      return
    return
  $('#next').click ->
    nextPage()
    return
  $('#prev').click ->
    prevPage()
    return
  return

window.onkeyup = (e) ->
  key = if e.keyCode then e.keyCode else e.which
  switch key
    when 39
      $('#next').click()
    when 37
      $('#prev').click()
    else
      console.log 'Key: ' + key
      break
  return