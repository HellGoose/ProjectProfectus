# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

disable = (btn)->
  btn.attr('disabled', true)

enable = (btn)->
  btn.attr('disabled', false)

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
  category = parseInt(data.getAttribute('data-category'))
  
  if page < (Math.ceil(size/interval))
    page += 1
    enable($('#prev'))
    if page == Math.ceil(size/interval)
      disable($('#next'))
  else
    disable($('#next'))

  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return

prevPage = ->
  page = parseInt(data.getAttribute('data-page'))
  interval = parseInt(data.getAttribute('data-interval'))
  category = parseInt(data.getAttribute('data-category'))
  if page > 1
    page -= 1
    enable($('#next'))
    if page == 1
      disable($('#prev'))
  else
    disable($('#prev'))
    if size > interval
      enable($('#next'))

  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  return


reset = ->
  page = parseInt(data.getAttribute('data-page'))
  interval = parseInt(data.getAttribute('data-interval'))
  category = parseInt(data.getAttribute('data-category'))
  size = parseInt(data.getAttribute('data-size'))
  page = 1
  disable($('#prev'))
  if size <= interval
    disable($('#next'))
  else
    enable($('#next'))
  $('#projects').load('/projects/page/' + category + '/' + page + '/' + interval)
  data.setAttribute('data-page', page)
  $('.catButton').attr('style', 'color: black')
  return

search = ->
  data.setAttribute('data-search', document.getElementById('searchText').value)
  console.log data.getAttribute('data-search')
  
  return

$(document).ready ->
  addNewProjectButton()
  data = document.getElementById('data')

  page = parseInt(data.getAttribute('data-page'))
  size = parseInt(data.getAttribute('data-size'))
  interval = parseInt(data.getAttribute('data-interval'))

  if page == 1
    disable($('#prev'))
  if size <= interval
    disable($('#next'))

  $('#next').click ->
    nextPage()
    return
  $('#prev').click ->
    prevPage()
    return
  $('.catButton').click ->
    data.setAttribute('data-category', parseInt(@id))
    data.setAttribute('data-size', parseInt(@name))
    reset()
    $('#'+@id+'.catButton').attr('style', 'color: gray')
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
      $('#next').click()
    when 37
      $('#prev').click()
    else
      console.log 'Key: ' + key
      break
  return