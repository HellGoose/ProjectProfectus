# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

changePage = (dir) ->
  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')

  if (dir == '>')
    if page < (Math.ceil(size/interval))
      page += 1
      $('#prev').attr('disabled', false)
      if page == Math.ceil(size/interval)
        $('#next').attr('disabled', true)
    else
      $('#next').attr('disabled', true)
  else if (dir == '<')
    if page > 1
      page -= 1
      $('#next').attr('disabled', false)
      if page == 1
        $('#prev').attr('disabled', true)
    else
      $('#prev').attr('disabled', true)
      if size > interval
        $('#next').attr('disabled', false)

  $('#news_container').load('/news/page/' + page + '/' + interval)
  $('#data').data('page', page)
  return

$(document).ready ->
  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')

  if page == 1
    $('#prev').attr('disabled', true)
  if size <= interval
    $('#next').attr('disabled', true)

  $('#next').click ->
    changePage('>')
    return
  $('#prev').click ->
    changePage('<')
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