# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

createNewProjectButton = ->
  listElement = document.createElement('li')
  linkElement = document.createElement('a')
  listElement.appendChild linkElement

  linkElement.innerHTML = 'New Project'
  linkElement.href = '/projects/new'

  menu = document.getElementById('menu')
  menu.insertBefore listElement, menu.childNodes[0]
  return

createNewProjectButton()