# Behaviors and hooks related to the Homepage controller.
#  All this logic will automatically be available in application.js.

# Requests a single State from the API by either the state postal abbreviation,
#  or by the full text state name (e.g., 'NY' or 'New York')
# @param String selector
#  The containing element in which a single state's gas info will be drawn.
# @param String stateName
#  Full text or postal-abbreviated state name.
# @param Function drawCallback
#  Callback function for printing the API response data to the page.
# @param Function errorCallback
#  Callback function for printing an error to the page.
# @return VOID
getStateNameAndGasPrice = (selector, stateName, drawCallback, errorCallback) ->
  $.ajax
    url: '/api/v1/states/' + stateName
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      errorCallback selector, 'Error: invalid US state.'
    success: (data, textStatus, jqXHR) ->
      if data.state
        drawCallback selector, data.state
      else
        errorCallback selector, 'Error: invalid US state.'

# Hits API for list of States and their gas prices. If prices are out of date,
#  or there are fewer than 50 States, the list is refreshed. This is called by
#  the document.ready routine, defined below.
# @param String selector
#  The containing element in which a single state's gas info will be drawn.
# @param Function drawCallback
#  Callback function for printing the API response data to the page.
# @param Function errorCallback
#  Callback function for printing an error to the page.
# @return VOID
getAllStateNamesAndGasPrices = (selector, drawCallback, errorCallback) ->
  $.ajax
    url: '/api/v1/states'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      errorCallback selector, 'There was an issue processing this request. Please try again.'
    success: (data, textStatus, jqXHR) ->
      if data.states
        drawCallback selector, data.states
      else
        errorCallback selector, 'Error: no states found'

# Draws / prints a state name and gas price to the selector.
# @param String selector
#  The containing element in which a single state's gas info will be drawn.
# @param Obj states
#  Object containing state name and gas price.
# @return VOID
drawStateData = (selector, state) ->
  $(selector).hide()
  list  = $('<ul>').addClass('state-list list-group')
  name  = $('<span>').addClass('state-name').text(state.name)
  price = $('<span>').addClass('state-price badge').text(state.price)
  list.append($('<li>').addClass('list-group-item').append(name).append(price))
  $(selector).html(list)
  $(selector).fadeIn 'fast', ->
    $(this).effect 'shake', {direction: 'down', distance: 10, times: 2}

# Draws / prints all state names and gas prices to the selector.
# @param String selector
#  The containing element in which a single state's gas info will be drawn.
# @param Obj states
#  Object containing list of state names and gas price objects.
# @return VOID
drawAllStateData = (selector, states) ->
  list = $('<ul>').addClass 'all-states-list list-group'
  for state in states
    name  = $('<span>').addClass('state-name').text(state.name)
    price = $('<span>').addClass('state-price badge').text(state.price)
    list.append $('<li>').addClass('list-group-item').append(name).append(price)
  $(selector).hide()
  $(selector).html list
  $(selector).fadeIn 'slow'

# Replaces the given selector's content with an error message
# @param String selector
#  The containing element in which an error will be printed.
# @param String message
#  The error to be printed.
# @return VOID
handleGasInfoErrors = (selector, message) ->
  $(selector).html message

# The document 'ready' loads actions for the initial page request, while
#  the 'page:load' event handles reloading of the page via any turbolinks.
$(document).on 'ready page:load', ->
  # Listen for button click
  $('#state-btn').on 'click', ->
    getStateNameAndGasPrice '#state-gas-price', $('#state-input').val(), drawStateData, handleGasInfoErrors

  # Detect 'Enter' key on input field
  $('#state-input').keypress (event) ->
    if event.keyCode == 13
      getStateNameAndGasPrice '#state-gas-price', $(this).val(), drawStateData, handleGasInfoErrors

  # Load initial data onto homepage from server
  getAllStateNamesAndGasPrices '#all-gas-prices', drawAllStateData, handleGasInfoErrors
