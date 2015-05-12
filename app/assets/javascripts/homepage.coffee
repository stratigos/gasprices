# Behaviors and hooks related to the Homepage controller.
#  All this logic will automatically be available in application.js.

# Requests a single State from the API by either the state postal abbreviation,
#  or by the full text state name (e.g., 'NY' or 'New York')
# @param String selector
#  The containing element in which a single state's gas info will be drawn.
# @param String state
#  The full text or postal-abbreviated state name.
getStateNameAndGasPrice = (selector, state) ->
  $.ajax
    url: '/api/v1/states/' + state
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      handleGasInfoErrors selector, 'Error: invalid US state.'
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
      else
        handleGasInfoErrors selector, 'Error: invalid US state.'

# Hits API for list of States and their gas prices. If prices are out of date,
#  or there are fewer than 50 States, the list is refreshed. This is called by
#  the document.ready routine, defined below.
# @param String selector
#   The containing element in which gas price information is drawn.
getStateNamesAndGasPrices = (selector) ->
  $.ajax
    url: '/api/v1/states'
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      handleGasInfoErrors selector, 'There was an issue processing this request. Please try again.'
    success: (data, textStatus, jqXHR) ->
      if data.states
        states = data.states
        list   = $('<ul>').addClass 'all-states-list list-group'
        for state in states
          name  = $('<span>').addClass('state-name').text(state.name)
          price = $('<span>').addClass('state-price badge').text(state.price)
          list.append $('<li>').addClass('list-group-item').append(name).append(price)
        $('#all-gas-prices').hide()
        $('#all-gas-prices').html list
        $('#all-gas-prices').fadeIn 'slow'
      else
        handleGasInfoErrors selector, 'Error: no states found'

# Replaces the given selector's content with an error message
handleGasInfoErrors = (selector, message) ->
  $(selector).html message

# The document 'ready' loads actions for the initial page request, while
#  the 'page:load' event handles reloading of the page via any turbolinks.
$(document).on 'ready page:load', ->
  # Listen for button click
  $('#state-btn').on 'click', ->
    getStateNameAndGasPrice '#state-gas-price', $('#state-input').val()

  # Detect 'Enter' key, since there is no real webform
  $('#state-input').keypress (event) ->
    if event.keyCode == 13
      getStateNameAndGasPrice '#state-gas-price', $(this).val()

  # Load initial data onto homepage from server
  getStateNamesAndGasPrices '#all-gas-prices'
  return
