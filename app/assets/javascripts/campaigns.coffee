# Place all the behaviors and hooks related to the matching controller here.

# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Sorts, filters and changes pages for the campaign list.
# Valid inputs are '>', '<' and 'reset'. 
# '>' changes to the next page. '<' changes to the previous page.
# 'Reset' basically goes to the first page of the current list.
# For the campaign loading a GET request is sent to the webserver
# and the controller returns the correct list based on the filters
# sorting and page. The list is then dynamically replacing the current list.
changePage = (dir) ->
  page = $('#data').data('page')
  size = $('#data').data('size')
  interval = $('#data').data('interval')
  category = $('#data').data('category')
  sortBy = $('#data').data('sort-by').replace(/ /g, '_')
  searchText = $('#data').data('search-text').replace(/ /g, '_')

  if (dir == 'reset')
    page = 1
  if (dir == '>')
    if page < (Math.ceil(size/interval))
      page += 1
      $('#prev').attr('disabled', false)
      if page == Math.ceil(size/interval)
        $('#next').attr('disabled', true)
    else
      $('#next').attr('disabled', true)
  else if (dir == '<')
    if page > 1
      page -= 1
      $('#next').attr('disabled', false)
      if page == 1
        $('#prev').attr('disabled', true)
    else
      $('#prev').attr('disabled', true)
      if size > interval
        $('#next').attr('disabled', false)
  else
    $.get '/campaigns/page/' + category + '/' + searchText, (data, status) ->
      $('#data').data('size', data.message)
      $('#prev').attr('disabled', true)
      if data.message <= interval
        $('#next').attr('disabled', true)
      else
        $('#next').attr('disabled', false)
      $('.catButton').attr('style', 'color: white')
      return

  $('#campaigns').load '/campaigns/page/' + category + '/' + page + '/' + interval+'/'+sortBy+'/'+searchText, (data, response) ->
    $('#data').data('page', page)
    return
  return

# Sets the search text in the custom data variable and resets the 
# campaign list.
search = ->
  searchText = $('#searchText').val()
  if searchText == ''
    searchText = ' '
  $('#data').data('search-text', searchText)
  changePage('reset')
  return

# Runs the code after the document is ready
$(document).ready ->
  # Recognizes which path the user is on.
  if (window.location.pathname == '/campaigns' || window.location.pathname == '/campaigns/')
    page = $('#data').data('page')
    size = $('#data').data('size')
    interval = $('#data').data('interval')

    # Initially disables button if there are no more campaigns on the next
    # page or the user is on page 1
    if page == 1
      $('#prev').attr('disabled', true)
    if size <= interval
      $('#next').attr('disabled', true)

    # Changes pages when the user clicks on the next and previous buttons.
    $('#next').click ->
      changePage('>')
      return
    $('#prev').click ->
      changePage('<')
      return

    # Sets the category when the user clicks on a category and resets
    # the current campaign list.
    $('.catButton').click ->
      $('#data').data('category', @id)
      $('#data').data('size', @name)
      changePage('reset')
      $('#'+@id+'.catButton').attr('style', 'color: black')
      return

    # Initiating a search when the user clicks the search button.
    $('#searchButton').click ->
      search()
      return

    # Sets the sorting filter based on what the user chooses
    # and resets the current campaign list.
    $('#sortBy').on 'change', ->
      $('#data').data('sort-by', $('#sortBy').find(':selected').val())
      changePage('reset')
      return

    # Changes pages when the user uses the arrow keys and initiating a
    # search when the user uses the enter key.
    window.onkeyup = (e) ->
      key = if e.keyCode then e.keyCode else e.which
      switch key
        when 13
          if $('#searchText').is(":focus")
            search()
        when 39
          if !($('#searchText').is(":focus"))
            $('#next').click()
        when 37
          if !($('#searchText').is(":focus"))
            $('#prev').click()
        else
          break
      return

  else if (window.location.pathname == '/campaigns/new')
    # Runs the embedly scraper when the user pastes a valid link
    # into the campaign_link input field. The code both checks if the 
    # link is a valid link and also where it goes.
    # After the scraper has returned data, a preview will be rendered and
    # the Submit button will be enabled. The Submit button will be disabled
    # if the link is invalid.
    $('#campaign_link').on 'input', ->
      $('#submitButton').attr('disabled', true)
      campaign = $('#campaign_link').val()
      validURLs = ['kickstarter.com', 'indiegogo.com']

      urlregex = new RegExp('^(http|https|ftp)://([a-zA-Z0-9.-]+(:[a-zA-Z0-9.&amp;%$-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]).(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0).(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0).(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9-]+.)*[a-zA-Z0-9-]+.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(:[0-9]+)*(/($|[a-zA-Z0-9.,?\'\\+&amp;%$#=~_-]+))*$')
      if urlregex.test(campaign) and new RegExp(validURLs.join("|")).test(campaign)
        $.embedly.extract(campaign, key: '0eef325249694df490605b1fd29147f5').progress (data) ->
          renderCampaignPreview(data)
          $('#submitButton').attr('disabled', false)
          return
      else
        clearCampaignPreview()
        return
      return
  return

# Renders a preview of the campaign the scraper received.
renderCampaignPreview = (data) ->
  $('#description-field').val(data.description)
  $('#image-field').val(data.images[0].url)
  $('#title-field').val(data.title)

  $('#campaign-image').attr('src', data.images[0].url)
  $('#campaign-title').html(data.title)
  $('#campaign-description').html(data.description)
  return

# Clears the campaign preview area
clearCampaignPreview = ->
  $('#description-field').val('')
  $('#image-field').val('')
  $('#title-field').val('')

  $('#campaign-image').attr('src', '')
  $('#campaign-title').html('')
  $('#campaign-description').html('')
  return