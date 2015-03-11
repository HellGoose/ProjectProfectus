# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
	$('#news').click ->
		$('#content').load('/admin/news')
		return
	$('#users').click ->
		$('#content').load('/admin/users')
		return
	$('#projects').click ->
		$('#content').load('/admin/projects')
		return
	$('#mods').click ->
		$('#content').load('/admin/mods')
		return
	return