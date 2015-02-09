# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.onload = ->
  name = document.getElementById('name')
  facebookLogin = document.getElementById('facebookLogin')
  logoutButton = document.getElementById('logout')

  facebookLogin.onclick = ->
    FB.getLoginStatus (response) ->
      if response.status == 'not connected'
        FB.login()
   	    FB.api '/me', (response) ->
          console.log response
          name.innerHTML = response.name
          return
      	return
      return
    return

  logout.onclick = ->
    FB.logout (response) ->
      name.innerHTML = 'Login'
      return
    return