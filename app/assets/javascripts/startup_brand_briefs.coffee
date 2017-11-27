# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.brief_btn_step').on 'click', ->
    $.myMethods.file_init3.call this

  $('body').on 'click', '.hidden_item a[data-toggle="collapse"]', (e) ->
    e.stopPropagation()
