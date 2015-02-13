# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


addNewProjectButton = ->
  btn = document.createElement('a')
  btn.type = 'button'
  btn.className = 'btn btn-default'
  btn.data-role = 'button'
  btn.innerHTML = 'New Project'
  btn.href = 'projects#new'
  menu = document.getElementById('menu')
  menu.insertBefore btn, menu.childNodes[0]
  return

addNewProjectButton()

