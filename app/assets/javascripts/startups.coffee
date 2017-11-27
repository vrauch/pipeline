$(document).ready ->
  $.myMethods =
    file_init3: ->
      currentPanel = undefined
      nextPanel = undefined
      currentPanel = $(this).closest('div.panel.panel-default')

      if $(this).hasClass('last_accordion_button')
        nextPanel = currentPanel.parents('.accordion_wizard').next().find('div.panel.panel-default').first()
        $(currentPanel).find('.panel-title a').click()
      else
        nextPanel = currentPanel.next()

      $(currentPanel).addClass 'visited'

      $.myMethods.check_if_disabled($(nextPanel))

      if $(nextPanel).hasClass('hidden_item')
        $(nextPanel).removeClass 'hidden_item'
        $(nextPanel).find('.panel-title a').click()
      else
        $(nextPanel).find('.panel-title a').click()
      false

    calendar_init: ->
      $('.calendar').datepicker(
        format: 'yyyy-mm-dd'
        maxViewMode: 0).on('changeDate', (e) ->
        $(this).siblings('.icon_calendar').css 'color', '#000'
      ).on 'clearDate', (e) ->
        $(this).siblings('.icon_calendar').css 'color', 'rgba(0,0,0,.3)'
      $('.calendar').on 'change', ->
        $('.datepicker').hide()

    check_if_disabled: (panel) ->
      check = 0
      if panel.find('input').length
        panel.find('input').each ->
          if $(this).is(':checked')
            check = 1
      else
        if panel.find('textarea').val().length > 1
          check = 1
        else
          check = 0
      if check == 1
        panel.find('.btn_step.js_scroll').removeClass('disabled').data('disabled', false)
      else
        panel.find('.btn_step.js_scroll').addClass('disabled').data('disabled', true)

      $('div[data-mandatory="true"]').each ->
        error = $(this).find('input:checked').length
        if $('textarea', $(this)).length
          error = $('textarea', $(this)).val().length
        if error
          $('.submit').removeAttr 'disabled'
        else
          $('.submit').attr 'disabled', 'disabled'
          return false
        return

  $("body").on "click", ".cancel", () ->
    $(this).parents('.action_forms').empty()
    $(this).parents('.new_startup').empty()

  $('.chosen-select').chosen disable_search: true

  $('.remove_first').remove()

  $('.startup-logo-input').previewImage '.inner.startup-logo-preview'
  $('.startup-logo-input').change ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'

  $('body').on 'click', '#logo_startup', (e) ->
    $('#upload_statup_logo').click();

  $('.logo_upload').click (e) ->
    $('.upload_file_holder .help_text').fadeOut()

  $('body').on 'click', '.push_to_brand', ->
    if $(this).find(".push-startup").length == 0
      $(this).addClass("clicked")
    return

  $('body').on 'click', '.add_to_list', ->
    if $(this).find(".push-startup").length == 0
      $(this).addClass("visible")
    return

  $('body').on 'click', '.invite_startup', ->
    if $(this).find(".push-startup").length == 0
      $(this).addClass("clicked")
    return

  $('body').on 'click', '.btn_tip_add', (e) ->
    $(this).parents('.tip_holder').find('#new_list_startup').submit()

  $("body").on "click", ".founder-avatar-input, .startup-logo-input", ->
    $(this).previewImage($(this).parents(".inner"))
    #$(this).parents(".default_upload_file").addClass("active")

  $('body').on 'click', '.export-type', (e) ->
    $('ul.dropdown-menu, li.export-type').each (i) ->
      $(this).removeClass('active')
    $(this).addClass('active')
    $('ul.dropdown-menu').fadeOut 250

  unless $('#startup_notification').length == 0
    $('.top_notification').addClass('full_width').showFlashMessage()

  if $('#profile-layout').length == 1
    $.publicMethods.initTags()

    $('body').on 'click', '.js__show__tags', ->
      $(this).parent().parent().toggleClass 'add__tag--opened'
      false

  if $('.ellipsis_text, .card_title').length
    $('.ellipsis_text, .card_title').dotdotdot()

  $('body').on 'keyup', '.tags__block--input, .tt-input', ->
    $(this).css('color', '#fff')

  $('body').on 'click', '.tt-menu', ->
    $(".tags__block--input").val('')

  $('body').on 'blur', '.tt-input', ->
    $(this).typeahead('val', '');

  $('body').on 'change', '.panel-body input', ->
    panel = $(this).parents('.panel.panel-default')
    $.myMethods.check_if_disabled(panel)

  $('body').on 'keyup paste', '.panel-body textarea', ->
    panel = $(this).parents('.panel.panel-default')
    $.myMethods.check_if_disabled(panel)

  $('body').on 'click', '.no_link', (e) ->
    return false

  $('body').on 'focus', '#details, #startup_website', ->
    if $(this).parents('.error_field').length > 0
      $(this).parents('.error_field').next('.mark_span').addClass('black')
    else
      $(this).next('.mark_span').addClass('black')

  $('body').on 'blur', '#details, #startup_website', ->
    unless $(this).val().length > 0
      if $(this).parents('.error_field').length > 0
        $(this).parents('.error_field').next('.mark_span').removeClass('black')
      else
        $(this).next('.mark_span').removeClass('black')

  $('body').on 'click', '.icon_star', ->
    $(this).removeClass('icon_star').addClass('icon_star_fill')
