# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('body').on 'click', '.remove_from_pushed', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $.ajax
      type: 'GET'
      url: $(this).data('path')
