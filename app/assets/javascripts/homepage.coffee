# Behaviors and hooks related to the Homepage controller.
#  All this logic will automatically be available in application.js.

# Requests a single State from the API by either the state postal abbreviation,
#  or by the full text state name (e.g., 'NY' or 'New York') 
stateinfo = (state) ->
  $.ajax
    url: '/api/v1/states/' + state
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      $('#state-gas-price').html "#{textStatus}: invalid US state"
    success: (data, textStatus, jqXHR) ->
      if data.state
        $('#state-gas-price').hide()
        state = data.state
        list  = $('<ul>').addClass('state-list list-group')
        name  = $('<span>').addClass('state-name').text(state.name)
        price = $('<span>').addClass('state-price badge').text(state.price)
        list.append($('<li>').addClass('list-group-item').append(name).append(price))
        $('#state-gas-price').html(list)
        $('#state-gas-price').fadeIn 'fast', ->
          $(this).effect 'shake', {direction: 'down', distance: 10, times: 2}
          #('shake', {distance:3}, 200);
      else
        $('#state-gas-price').text('error: invalid US state')

# Hits API for list of States and their gas prices. If prices are out of date,
#  or there are fewer than 50 States, the list is refreshed. This is called by
#  the document.ready routine, defined below.
allstateinfo = ->
  $.ajax
    url: '/api/v1/states'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      $('#all-gas-prices').html "#{textStatus} : #{errorThrown}"
    success: (data, textStatus, jqXHR) ->
      if data.states
        states = data.states
        list   = $('<ul>').addClass 'all-states-list list-group'
        for state in states
          name  = $('<span>').addClass('state-name').text(state.name)
          price = $('<span>').addClass('state-price badge').text(state.price)
          list.append $('<li>').addClass('list-group-item').append(name).append(price)
        $('#all-gas-prices').html list
      else
        $('#all-gas-prices').text 'error: no states found'

# The document 'ready' loads actions for the initial page request, while
#  the 'page:load' event handles reloading of the page via turbolinks.
$(document).on 'ready page:load', ->
  $('#state-btn').on 'click', ->
    stateinfo $('#state-input').val()
  allstateinfo()
  return
