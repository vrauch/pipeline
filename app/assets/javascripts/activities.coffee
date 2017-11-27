# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery(document).ready ->

  $("body").on "click", "#reminders-activity, #requests-activity, #updates-activity, #all-activity", () ->
    $.ajax
      type: 'GET'
      url: $(this).data('url')
  $('body').on 'click', '.activity_link', (e) ->
    e.stopPropagation()
