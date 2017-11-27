# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("body").on 'click', '.add_promo_page, .edit_promo_page, .view_question, .preview', (event) ->
    $.controlMethods.showPanel($(this).data('panel'))

  $('body').on 'focus', '#add_question', ->
    $(this).addClass("hidden")
    $(this).parents('.slide-panel-content').find('.bot_control_btns').fadeOut()
    $("[data-association=promo_page_question]").trigger("click")
    last = $("#questions .grid_padding_sm:last")
    last.find("[data-association=promo_page_question_answer]").trigger("click").trigger("click")
    last.find('.question_remove').remove()
    last.find(".add_guestion").focus()

  $("body").on 'change', '.promo_answer_type input', ->
    checked = $(this)
    answers = $(".grid_padding_sm:visible").find(".abc_list li")
    add_answer = $(".grid_padding_sm:visible").find(".abc_list .links")
    if checked.val() == 'text'
      answers.remove()
      add_answer.addClass("hidden")
    else
      if answers.length == 0
        add_answer.removeClass("hidden")
        last = $(".grid_padding_sm:visible")
        last.find("[data-association=promo_page_question_answer]").trigger("click").trigger("click")

  $('body').on 'change', '.cover-image-input, .inspire-image-input, .form-image-input', ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'
    return

  $("body").on "change", ".cover-image-input, .inspire-image-input, .form-image-input", ->
    $('.spinner').addClass('active');
    action = $("#manage_promo_page").attr("action")
    refreshAction = $("#manage_promo_page").data("refresh")
    $("#manage_promo_page").attr("action", refreshAction).submit().attr("action", action)

  $("body").on "click", ".cover-image-input, .inspire-image-input, .form-image-input", ->
    $(this).previewImage($(this).parents(".inner"));

  $("body").on "click", ".back-from-preview", ->
    $(".promo_page_preview").removeClass('is-visible');
    $('body').css 'overflow-y', 'auto'
    $("#promo_page_preview").html("");

  $('body').on 'click', '#cancel-promo-page-reject', (e) ->
    $('.promo__bar--reject').fadeOut(400);

  $('body').on 'keyup', '#reason', ->
    $('#reason').css 'border-width': '0px'

  $('body').on 'click', '.js__reject__promo', ->
    $("#promo_page_preview").find('.promo__bar--reject').fadeIn 'fast', ->
      $('.promo__bar--reject_text').focus()
      return
    false
  $('body').on 'click', '.js__cancel__reject', ->
    $('.promo__bar--reject').fadeOut 'fast'
    false

  $('body').on 'click', '.goto_sign_up', ->
    $('html, body').animate({
      scrollTop: $("#sign_up").offset().top
    }, 1000)

  $('body').on 'click', '.js__smooth__scroll', ->
    destination = $('.js__smooth__scroll').offset().top + 64
    $('html, body').animate({ scrollTop: destination }, 500)

  $('.reached_limit').click ->
    $(this).parents('.show_tip').addClass('visible')

  $('body').on 'click', '#intro_image, #sign_up_image', ->
    $('.upload_img').click();

  $('body').on 'click', '.add_video>span', ->
    add_video = $(this).parents('.add_video')
    video_url = add_video.siblings('.add_vid_hidden_block')
    video_url.fadeIn()
    add_video.hide()
    $('.form-control', video_url).focus()

  $('body').on 'click', '.add_vid_hidden_block .remove-video', ->
    input =
      if $(this).siblings('input.inspire-video').length
        $(this).siblings('input.inspire-video')
      else
        $(this).siblings('.error_field').find('input.inspire-video')
    input.val('')
    parent = $(this).parents('.add_vid_hidden_block')
    parent.hide()
    parent.siblings('.add_video').fadeIn()
    $.promoPageMethods.refresh()

  $('body').on 'click', '.upload-video', (e) ->
    $.promoPageMethods.refresh()

  $('body').on 'click', '.promo_link_item.reject', (e) ->
    e.preventDefault()
    $(this).find('.promo__bar--reject').fadeIn 'fast', ->
      $('.promo__bar--reject_text').focus()
      return
    $(this).siblings('.tooltip').hide()
    return

  $('body').on 'click', '.btn_show_mark.reject', ->
    $(this).parents("form").submit()

  $(document).mouseup (e) ->
    container = $('.promo__bar--reject')
    if !container.is(e.target) and container.has(e.target).length == 0
      $('.promo__bar--reject').hide()

  $.promoPageMethods =
    videoBlock: ->
      $('.inspire-video').each ->
        if $(this).val().length
          videoHolder = $(this).parents('.add_vid_hidden_block')
          videoHolder.show()
          videoHolder.siblings('.add_video').hide()
          videoHolder.siblings('.default_upload_file').find('.upload_text.visible_before').hide()
    refresh: ->
      action = $("#manage_promo_page").attr("action")
      refreshAction = $("#manage_promo_page").data("refresh")
      $("#manage_promo_page").attr("action", refreshAction).submit().attr("action", action)
