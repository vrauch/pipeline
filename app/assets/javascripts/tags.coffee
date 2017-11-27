# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
#  $.publicMethods.initTags()
  $('body').on 'focus', '.inner_field_search', (e) ->
    $('.inner_search').addClass 'active_search'
    $(document).mouseup (e) ->
      container = $('.inner_search')
      if !container.is(e.target) and container.has(e.target).length == 0
        $('.inner_search').removeClass 'active_search'
