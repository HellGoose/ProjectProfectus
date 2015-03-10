# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

nextPage = ->
  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  category = $('#data').data('category')
  
  if page < (Math.ceil(size/interval))
    page += 1
    $('#prev').attr('disabled', false)
    if page == Math.ceil(size/interval)
      $('#next').attr('disabled', true)
  else
    $('#next').attr('disabled', true)

  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  $('#data').data('page', page)
  return

prevPage = ->
  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  category = $('#data').data('category')

  if page > 1
    page -= 1
    $('#next').attr('disabled', false)
    if page == 1
      $('#prev').attr('disabled', true)
  else
    $('#prev').attr('disabled', true)
    if size > interval
      $('#next').attr('disabled', false)

  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  $('#data').data('page', page)
  return


reset = ->
  page = 1
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  category = $('#data').data('category')

  $('#prev').attr('disabled', true)
  if size <= interval
    $('#next').attr('disabled', true)
  else
    $('#next').attr('disabled', false)
  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  $('#data').data('page', page)
  $('.catButton').attr('style', 'color: white')
  return

$(document).ready ->
  $('#menu').prepend('<li><a href="/projects/new">New Project</a></li>')

  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')

  if page == 1
    $('#prev').attr('disabled', true)
  if size <= interval
    $('#next').attr('disabled', true)

  $('#next').click ->
    nextPage()
    return
  $('#prev').click ->
    prevPage()
    return

  $('.catButton').click ->
    $('#data').data('category', @id)
    $('#data').data('size', @name)
    reset()
    $('#'+@id+'.catButton').attr('style', 'color: black')
    return

  $('#searchButton').click ->
    $('#data').data('search', $('#searchText').val())
    return
  return

window.onkeyup = (e) ->
  key = if e.keyCode then e.keyCode else e.which
  switch key
    when 13
      if $('#searchText').focus
        search()
    when 39
      $('#next').click()
    when 37
      $('#prev').click()
    else
      console.log 'Key: ' + key
      break
  return