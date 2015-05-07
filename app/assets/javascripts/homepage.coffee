# Behaviors and hooks related to the Homepage controller.
#  All this logic will automatically be available in application.js.

stateinfo = (state) ->
  console.log 'Retrieving gas price for state: ' + state

allstateinfo = ->
  console.log 'Retrieving gas prices for all states'

# The document 'ready' loads actions for the initial page request, while
#  the 'page:load' event handles reloading of the page via turbolinks.
$(document).on 'ready page:load', ->
  allstateinfo()
  return
