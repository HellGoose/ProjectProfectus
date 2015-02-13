# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###
window.fbAsyncInit = ->
  FB.init(
    appId: '820192964704242'
    xfbml: true
    version: 'v2.1'
  )

  FB.getLoginStatus (response2) ->
    FB.api '/me', (response) ->
      document.getElementById('name').innerHTML = response.first_name + ' ' + response.last_name if (response2.status == 'connected')
      return
    return

  $('#logout').click (e) ->
    FB.getLoginStatus (response) ->
      FB.logout() if response.authResponse
      return
    return
  return

((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  if d.getElementById(id)
    return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/en_US/sdk.js'
  fjs.parentNode.insertBefore js, fjs
  return
) document, 'script', 'facebook-jssdk'
###