# Place all the behaviors and hooks related to the matching controller here.

# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Opens a new window when the user presses the refer-a-friend button.
# The window opens in the middle of the screen and loads 'root/refer-a-friend'.
$(document).on 'click', '#refer-a-friend', ->
  left = (screen.width/2)-(500/2)
  top = (screen.height/2)-(470/2)
  window.open('/refer_a_friend', '_blank', 'toolbar=no, 
    scrollbars=no, resizable=no, top=' + top + ', left=' + left + ', width=500, height=470')
  return
