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

$(document).ready ->
  addNewProjectButton()
  $('#next').click ->
    $('#projects').load '/projects/next'
    return
  $('#prev').click ->
    $('#projects').load '/projects/prev'
    return
  return


window.onkeyup = (e) ->
  key = if e.keyCode then e.keyCode else e.which
  switch key
    when 39
      $('#projects').load '/projects/next'
    when 37
      $('#projects').load '/projects/prev'
    else
      console.log 'Key: ' + key
      break
  return