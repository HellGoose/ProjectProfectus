# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addNewProjectButton = ->
  listElement = document.createElement('li')
  linkElement = document.createElement('a')
  listElement.appendChild linkElement

  linkElement.innerHTML = 'New Project'
  linkElement.href = '/projects/new'

  menu = document.getElementById('menu')
  menu.insertBefore listElement, menu.childNodes[0]
  return

nextPage = ->
  page = parseInt(data.getAttribute('data-page'))
  size = parseInt(data.getAttribute('data-size'))
  interval = parseInt(data.getAttribute('data-interval'))
  page += 1
  if (page >= Math.floor(size / interval) + 1)
    page = Math.floor(size / interval) + 1
  $('#projects').load('/projects/page/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return

prevPage = ->
  page = parseInt(data.getAttribute('data-page'))
  interval = parseInt(data.getAttribute('data-interval'))
  page -= 1
  if page < 1
    page = 1
  $('#projects').load('/projects/page/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return

search = ->
  data.setAttribute('data-search', document.getElementById('searchText').value)
  console.log data.getAttribute('data-search')
  return

$(document).ready ->
  addNewProjectButton()
  data = $('#data')
  $('#next').click ->
    nextPage()
    return
  $('#prev').click ->
    prevPage()
    return
  $('#searchButton').click ->
    search()
    return
  return

window.onkeyup = (e) ->
  key = if e.keyCode then e.keyCode else e.which
  switch key
    when 13
      if $('#searchText').focus
        search()
    when 39
      nextPage()
    when 37
      prevPage()
    else
      console.log 'Key: ' + key
      break
  return