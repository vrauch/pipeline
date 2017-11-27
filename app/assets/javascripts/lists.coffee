# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('body').on 'click', '.delete_card', (e) ->
    $(this).parents('.add_card_block').siblings('.card_alert').fadeIn 400

  $('body').on 'click', '.btn_cancel_remove', (e) ->
    $(this).parents('.card_alert').fadeOut 400
    $(this).parents('.card_alert').find('.btn_remove_card').removeClass 'active'

  $('body').on 'click', '#resetSorting', (e) ->
    $(this).addClass('btn_load')
