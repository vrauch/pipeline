# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery(document).ready ->

  $('.hide_show_details').on 'click', (event) ->
    $(this).text (i, text) ->
      if text == 'View Details' then 'Hide Details' else 'View Details'
    $('.sidebar_detail_body').toggleClass 'active'
    event.preventDefault()
    return

  $('body').on 'keyup', '.picked_color', ->
    $('.element_change_color').css 'background-color', $(this).val()

  $(document).on "mouseenter", ".custom_dropdown", ->
    $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn 300

  $(document).on "mouseleave", ".custom_dropdown", ->
    $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut 300

  $("body").on "click", ".dots_link", (e) ->
    $(this).parent().addClass 'active'
    e.preventDefault()

  $(document).mouseup (e) ->
    container = $('.slide_icons')
    if !container.is(e.target) and container.has(e.target).length == 0
      $('.links_box').removeClass 'active'

  $('body').on 'click', '.sort-type', (e) ->
    $('ul.dropdown-menu, li.sort-type').each (i) ->
      $(this).removeClass('active')
    $(this).addClass('active')
    $('ul.dropdown-menu').fadeOut 250


  $('body').on 'keyup', '.request_field', ->
    if $(this).val().length > 1
      $(this).parents('.panel-body').find('.btn.btn_add').removeClass('disabled').removeAttr('disabled')
    else
      $(this).parents('.panel-body').find('.btn.btn_add').addClass('disabled').attr('disabled', 'disabled')

  $("body").on "click", ".cancel", () ->
    $(".push-startup").empty()


#  $("body").on 'click', '.btn_open_panel', (event) ->
#    btn = $(this).data('panel')
#    $('.slide-panel[data-btn="' + btn + '"]').addClass 'is-visible'
#    $('body').css 'overflow-y', 'hidden'
#    numPanelsOpened2 = $('.is-visible').length
#    if numPanelsOpened2 > 1
#      $('.slide-panel[data-btn="' + btn + '"]').addClass 'transparent_overlay'

  $("body").on 'click', '.add_brand, .edit_brand', (event) ->
    $.controlMethods.showPanel($(this).data('panel'))


  $('body').on 'click', '.dismiss_one_panel', (event) ->
    $(this).parents('.slide-panel').removeClass 'is-visible'
    $('body').css 'overflow-y', 'auto'

  $('body').on 'click', '.close_accordion_item', (e) ->
    $('.close_accordion_item').removeClass 'active'
    $(this).parents('.panel').children('.panel-collapse').collapse 'hide'
    $(this).siblings('.slide_accordion').attr 'data-toggle', 'collapse'
    e.preventDefault()

  $('body').on 'click', '.slide_accordion', (e) ->
    $('.close_accordion_item').removeClass 'active'
    if $(this).parents('.panel').not('.panel_default_close').children('.panel-collapse').hasClass('in')
      if !$(e.target).data('remote')
        e.stopPropagation()
      $(this).parents('.panel').find('.close_accordion_item').addClass 'active'
    else
      $(this).parents('.panel').find('.close_accordion_item').addClass 'active'
    return

  $('body').on 'click', '.panel_default_close .slide_accordion', (e) ->
    if $(this).parents('.panel').children('.panel-collapse').hasClass('in')
      $('.close_accordion_item').removeClass 'active'
    return

  $('body').on 'click', '.btn_add_question', (e) ->
    e.preventDefault()
    $(this).parents(".grid_padding_sm").find("input.first_init").val(false)
    $.ajax
      type: 'POST'
      url: $(this).attr('href')
      data: $(this).parents('form').serialize()
    return

  $('body').on 'click', '.btn_update_question', (e) ->
    e.preventDefault()
    $.ajax
      type: 'POST'
      url: $(this).attr('href')
      data: $(this).parents('form').serialize()
    return


  $(".add_question_button").on 'cocoon:before-insert', (e, insertedItem) ->
    question_data_id = insertedItem.find("input.add_guestion").attr("id")
    insertedItem.find("input.question_data_id").val(question_data_id)
    insertedItem.attr('question-data-id', question_data_id)
    return

  $("body").on 'click', '.edit-question', () ->
    question_data_id = $(this).data("edit")
    question_block = $("[question-data-id='" + question_data_id + "']")
    $(".grid_padding_sm").addClass("hidden");
    $("#temporary-question-holder").html(question_block.html())
    $(this).parents('.slide-panel-content').find('.bot_control_btns').fadeOut()
    $("#add_question").addClass("hidden")
    question_block.removeClass('hidden')
#    destination = $(".form-control.add_guestion:visible").offset().top
#    console.log(destination)
#    $('.slide-panel-container').animate({ scrollTop: destination }, 1000)
    return

  $("body").on "click", ".remove-question", (e) ->
    self = $(this)
    e.preventDefault()
    self.parents("li").fadeOut(200)
    question_data_id = self.data("remove")
    self.parents('.slide-panel-content').find('.bot_control_btns').fadeIn()

    if self.data('persisted') == true
      $("[question-data-id='" + question_data_id + "']").find('.remove-question-hidden').trigger("click")
      setTimeout (->
        $.ajax
          type: 'DELETE'
          url: self.attr('href')
          data: self.parents('form').serialize()
          success: () ->
            $("[question-data-id='" + question_data_id + "']").next("input").remove()
            $("[question-data-id='" + question_data_id + "']").remove()
        return
      ), 100
    else
      $("[question-data-id='" + question_data_id + "']").remove()
    $("#add_question").removeClass("hidden")
    return

  $('body').on 'click', '.add_guestion', (e) ->
    $('.slide_block').slideDown()
    $(this).parents('.slide-panel-content').find('.bot_control_btns').fadeOut()
    $(this).parents('.slide-panel-container').siblings('.bot_control_btns').fadeOut()


  $("body").on 'click', '.btn_cancel_question', ->
    parent = $(this).parents(".grid_padding_sm")
    first_init = parent.find(".first_init").val()
    $(this).parents('.slide-panel-content').find('.bot_control_btns').fadeIn()

    if first_init == ''
      parent.remove()
    else
      parent.addClass("hidden").html($("#temporary-question-holder").html())
    $("#add_question").removeClass("hidden")

  $('body').on 'focus', '#add_question', ->
    $(this).addClass("hidden")
    $(this).parents('.slide-panel-content').find('.bot_control_btns').fadeOut()
    $("[data-association=brand_question]").trigger("click")
    last = $("#questions .grid_padding_sm:last")
    last.find("[data-association=brand_question_answer]").trigger("click").trigger("click")
    last.find('.question_remove').remove()
    last.find(".add_guestion").focus()

  $("body").on 'change', '.brand_answer_type input', ->
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
        last.find("[data-association=brand_question_answer]").trigger("click").trigger("click")
        $('.question_remove:lt(2)').remove()

  $('body').on 'change', '.logo-image-input', ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'
    return

  $('body').on 'change', '.email-logo-image-input', ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'
    return

  $('body').on 'keyup', '.simple_search', ->
    $(this).parents('.tip_holder').find('.tip_group_btns').fadeOut 400
    $('.tip_body').css 'padding-bottom', '0'
    $('.tip_holder .custom_scroll').mCustomScrollbar 'update'
    $(this).parents('form').submit()
    return


  $('body').on 'click', '.btn_tip_add', (e) ->
    $(this).parents('.tip_holder').find('#new_brand_startup').submit()

  $('body').on 'click', '.btn_tip_cancel', (e) ->
    $(this).parents('.show_tip').removeClass 'visible'
    tipHolder = $(this).parents('.tip_holder')
    tipHolder.find('.tip_group_btns').fadeOut 400
    setTimeout (->
      tipHolder.remove()
#      $('.tip_body').css 'padding-bottom', '0'
#      $('.tip_holder .custom_scroll').mCustomScrollbar 'update'
      return
    ), 500
    e.stopPropagation()
    e.preventDefault()
    return

  $('body').on 'click', '.tip_item:not(.disabled)', ->
    $(this).parents('.tip_holder').find('.tip_group_btns').fadeIn 400
    $(this).parents('.tip_holder').find('.tip_body').css 'padding-bottom', '51px'
    $('.tip_holder .custom_scroll').mCustomScrollbar 'update'
    return

  $('body').on 'click', '.tip_item.disabled', ->
    $(this).parents('.tip_holder').find('.tip_group_btns').fadeOut 400
    $(this).parents('.tip_body').css 'padding-bottom', '0'
    $('.tip_holder .custom_scroll').mCustomScrollbar 'update'
    return

  $('body').on 'click', '.push_startup_to_brand', (e) ->
    if $(this).find(".push-startup").length == 0
      $(this).addClass("clicked")
    return

  $("body").on "change", ".logo-image-input, .email-logo-image-input", ->
    action = $("#manage_brand").attr("action")
    refreshAction = $("#manage_brand").data("refresh")
    $("#manage_brand").attr("action", refreshAction).submit().attr("action", action)

  $('body').on 'click', '#info_logo, #email_logo', ->
    $('.upload_img').click();

#  $('body').on 'focus', '.add_answer:last', ->
#    focused = $(this).parents("li")
#
#    $(".abc_list li:gt(1)").each ->
#    unless focused.prev().find(".add_answer").val().length == 0
#      $(this).parents('.grid_padding_sm').find("[data-association=brand_question_answer]").trigger("click")
#
#  $('body').on 'blur', '.add_answer', ->
#    focused = $(".abc_list li input:focus")
#    ap focused
#    $(".abc_list li:gt(1)").each ->
#      unless $(this) == focused
#        $(this).remove()
