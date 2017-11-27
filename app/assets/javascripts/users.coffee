# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->

  $(document).mouseup (e) ->
    container = $('.add_card_block, .card_alert')
    if !container.is(e.target) and container.has(e.target).length == 0
      $('.add_card_block, .card_alert').fadeOut 400
    return
  $(document).on 'click', '.add_card_block .btn_cancel_card', ->
    $('.add_card_block').fadeOut 400
    $('.add_card_block .btn_invite_card').removeClass 'active'
    return

  $("body").on "click", ".edit_profile", ->
    $.controlMethods.showPanel('edit_profile')

  $('body').on 'change', '.upload_photo_img, .upload_img', ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'
    return

  $("body").on "click", ".upload_photo_img", ->
    $(this).previewImage($(this).parents(".inner"));

  $('body').on 'click', '#logo_user', ->
    $('.upload_img').click();


  $("body").on 'click', '.edit_email_link', ->
    parent_block = $(this).parents(".resend-invite-block")
    parent_block.find(".pre-resend").addClass('hidden')
    parent_block.find(".resend-form-input").removeClass("hidden")
