# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


nextPage = ->
  page = parseInt(data.getAttribute('data-page'))
  size = parseInt(data.getAttribute('data-size'))
  interval = parseInt(data.getAttribute('data-interval'))
  forum = parseInt(data.getAttribute('data-forum'))
  page += 1
  if (page > Math.ceil(size / interval))
    page = Math.ceil(size / interval)
  $('#topics').load('/forum/' + forum + '/page/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return

prevPage = ->
  page = parseInt(data.getAttribute('data-page'))
  interval = parseInt(data.getAttribute('data-interval'))
  forum = parseInt(data.getAttribute('data-forum'))
  page -= 1
  if page < 1
    page = 1
  $('#topics').load('/forum/' + forum + '/page/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return

$(document).ready ->
  data = document.getElementById('data')
  $('#voteButton').click ->
    $.post document.URL + '/vote', (data, status) ->
      voteSpan = document.getElementById('votes')
      votes = parseInt(voteSpan.innerHTML)

      if $('#voteButton').html() == 'Vote'
        $('#voteButton').html('Unvote')
        voteSpan.innerHTML = votes + 1
      else
        $('#voteButton').html('Vote')
        voteSpan.innerHTML = votes - 1
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
      nextPage()
    when 37
      prevPage()
    else
      console.log 'Key: ' + key
      break
  return