# Behaviors and hooks related to the Homepage controller.
#  All this logic will automatically be available in application.js.

# Requests a single State from the API by either the state postal abbreviation,
#  or by the full text state name (e.g., 'NY' or 'New York') 
stateinfo = (state) ->
  console.log 'Retrieving gas price for state: ' + state

# Hits API for list of States and their gas prices. If prices are out of date,
#  or there are fewer than 50 States, the list is refreshed.
allstateinfo = ->
  console.log 'Retrieving gas prices for all states'
  $.ajax
    url: '/api/v1/states'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      if data.states
        states = data.states
        list   = $('<ul>').addClass('all-states-list list-group')
        for state in states
          name  = $('<span>').addClass('state-name').text(state.name)
          price = $('<span>').addClass('state-price badge').text(state.price)
          list.append($('<li>').addClass('list-group-item').append(name).append(price))
        $('#all-gas-prices').html(list)
      else
        $('#all-gas-prices').text('No States Found')

# The document 'ready' loads actions for the initial page request, while
#  the 'page:load' event handles reloading of the page via turbolinks.
$(document).on 'ready page:load', ->
  allstateinfo()
  return
