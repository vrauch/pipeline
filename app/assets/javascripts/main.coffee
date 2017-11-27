flashMessage = (msgText = '', msgTitle = 'done') ->
  msg =
    '<div class="top_notification notice" style="z-index: 99999;">' +
      '<span class="notification_icon"><i class="icon icon_mark"></i></span>' +
      '<div class="top_notification_title">' + msgTitle.toUpperCase() + '</div>' +
      '<div class="top_notification_text">' + msgText + '</div>' +
    '</div>'

  if $('.list_holder').length
    $("#notification").html(msg)
    $('.top_notification').showFlashMessage()
  else if $("#full_width_notification").length
    $("#full_width_notification").html(msg)
    $('.top_notification').addClass('full_width').showFlashMessage()
  else
    $("#notification").html(msg)
    $('.top_notification').addClass('sm_size').showFlashMessage()

editItem = (element)->
  $('.editable').removeClass 'item_opened'
  $('.editable_btns').remove()
  $(element).parent().addClass 'item_opened'
  $(element).parent().find('.hidden_input').focus()
  $(element).parents('.editable').append '<div class="editable_btns invers_btns"><a href="#" class="btn btn_bordered_const btn_cancel_editable">Cancel</a><a href="#" class="btn btn_add btn_save_editable">Save</a></div>'

$(document).ready ->

  $.publicMethods =
    initTags: () ->
      gon.watch
      tags = new Bloodhound(
        datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
        queryTokenizer: Bloodhound.tokenizers.whitespace
        limit: 15
        remote:
          url: gon.startup_tags_path + "?query=%QUERY"
          wildcard: '%QUERY'
          filter: (list) ->
            $.map list, (tag) ->
              { name: tag }
      )

      tags.initialize()

      tagApi = $('.tags__block--input').tagsManager(
        delimiters: [44, 188, 13]
        prefilled: gon.predefined_tags
        AjaxPush: gon.startup_tags_path
        tagsContainer: $('.tags__block--tags')
        backspace: false)

      $('.tags__block--input').typeahead(null,
        name: 'tags'
        displayKey: 'name'
        source: tags.ttAdapter()).on 'typeahead:selected', (e, d) ->
          tagApi.tagsManager 'pushTag', d.name

      $('.tags__block--input').on 'tm:spliced tm:popped', (event, tag) ->
        $.ajax
          type: 'DELETE'
          url: gon.startup_tags_path + '/' + tag

      $('.tags__block--input').on 'tm:pushed', (e, tag) ->
        $('.tt-menu').hide()

  $(document).mouseup (e) ->
    container = $(".tip_holder")
    if !container.is(e.target) and container.has(e.target).length == 0
      $('.show_tip').removeClass('visible clicked')
      # WTF???
      $('.tip_holder:not(.tsip_limit, .sc_link_tip, .tip_sortable)').remove()
    return

  sideslider = $('[data-toggle=collapse-side]')
  sel = sideslider.attr('data-target')
  sel2 = sideslider.attr('data-target-2')
  sideslider.click (event) ->
    $(sel).toggleClass 'in'
    $(sel2).toggleClass 'out'
    return

  $.controlMethods =
    showPanel: (btn) ->
      slidePanel = $('.slide-panel[data-btn="' + btn + '"]')
      slidePanel.find('.slide-panel-container').scrollTop(0)
      slidePanel.addClass 'is-visible'
      $('body').css 'overflow-y', 'hidden'
      numPanelsOpened2 = $('.is-visible').length
      if numPanelsOpened2 > 1
        $('.slide-panel[data-btn="' + btn + '"]').addClass 'transparent_overlay'
    hidePanel: (btn, dis = false) ->
      $('.slide-panel[data-btn="' + btn + '"]').removeClass 'is-visible'
      style = if dis then 'hidden' else 'auto'
      $('body').css 'overflow-y', style
    hideAllPanels: ->
      $('.slide-panel').removeClass 'is-visible'
      $('body').css 'overflow-y', 'auto'
    removePlaceholder: ->
      $('.placeholder_styles').remove()

  $.fn.showFlashMessage = ->
    self = $(this)
    setTimeout (->
      self.addClass 'active'
      return
    ), 600
    setTimeout (->
      self.removeClass 'active'
      return
    ), 4000

  $('.slide-panel').on 'click', (event) ->
    if $(event.target).is('.slide-panel') or $(event.target).is('.dismiss_panels')
      $('.slide-panel').removeClass 'is-visible'
      $('body').css 'overflow-y', 'auto'

  $('[data-toggle=tooltip]').tooltip()

  $('body').on 'click', '.edit_card', (e) ->
    e.preventDefault()
    e.stopPropagation()
    $.ajax
      type: 'GET'
      url: $(this).data('path')

  if $('.sign_up_form_title').length
    $('.left_block_content').removeClass 'arrow_right_sm'

  if $('a.navbar-brand').hasClass("mobile_brand") and window.matchMedia('(max-width: 991px)').matches
    $('a.navbar-brand').addClass('mobile_logo')

  $( window ).resize ->
    if $( window ).width() < 992
      $('a.navbar-brand.mobile_brand').addClass('mobile_logo')
    else
      $('a.navbar-brand.mobile_brand').removeClass('mobile_logo')
      
    $(".slide-panel .fixed_control_btns").each ->
      btnsWidth = $(this).parents('.slide-panel').find('.slide-panel-content').innerWidth()
      $(this).css('width', btnsWidth)

  $('body').on 'click', '.btn_loader', ->
    $(this).addClass('btn_load')

  $('body').on 'click', '.btn_load', ->
    return false

  $('.top_notification').showFlashMessage()

  $('.slide-panel .fixed_control_btns').each ->
    btnsWidth = $(this).parents('.slide-panel').find('.slide-panel-content').innerWidth()
    $(this).css 'width', btnsWidth

  $('body').on 'click', '.edit_link', (e) ->
    editItem(this)

  $('body').on 'dblclick', '.editable_text', (e) ->
    editItem(this)

  $('body').on 'click', '.btn_cancel_editable', (e) ->
    $(this).parents('.editable').removeClass 'item_opened'
    input = $(this).parents('.editable').find('.hidden_input')
    input.val(input.data('default-val'))
    $(this).parent().remove()

  $('body').on 'click', '.btn_save_editable', (e) ->
    $(this).parents('.editable').removeClass 'item_opened'
    input = $(this).parents('.editable').find('.hidden_input')
    input.data('default-val', input.val())
    if input.val().length > 0
      $(this).parents('.editable').find('.hidden_input_value').text(input.val())
    else
      $(this).parents('.editable').find('.hidden_input_value')
        .html('<span class="some-transparency">none specified</span>')
    $(this).parent().remove()

  $('body').on 'keyup', '*[data-max-length]', (e) ->
    # if (e.which < 0x20)
    #   return
    max = parseInt($(this).data('max-length'))
    chars_left = max - this.value.length
    if(chars_left == 0)
      e.preventDefault()
    else if(chars_left < 0)
      this.value = this.value.substring(0, max)
      chars_left = 0
    parent = $(this).parent();
    text = 'characters';
    if $(this).data('small-field')
      text = 'char';
    if parent.hasClass('error_field')
      parent.parent().find('.limit_text').text(chars_left + ' ' + text)
    else
      parent.find('.limit_text').text(chars_left + ' ' + text)

  $('body').on 'change', '.upload_img', ->
    $(this).parents('.default_upload_file_holder').find('.default_upload_file').addClass 'active'

  $('body').on 'click', '.hide-fw-slide-panel', (e) ->
    e.preventDefault()
    $('#fwSlidePanel').parents('.slide-panel').removeClass('is-visible')

  $('body').on 'click', '[data-copy-input]', (e) ->
    input = $(this).data('copy-input')
    $(input).select()
    document.execCommand('copy')

    flashMessage($(this).data('msg-text'), $(this).data('msg-title'))

  $('body').on 'focus', '.has_text_limit input', (e) ->
    $(this).parents('.has_text_limit').find(".limit_text").show()

  $('body').on 'blur', '.has_text_limit input', (e) ->
    $(this).parents('.has_text_limit').find(".limit_text").hide()

  # $('.js-example-basic-single').select2
  #   templateResult: formatImg
  #   dropdownParent: $('.single_select')
  # $('#cust_sel').on 'select2:open', ->
  #   $('.select2-search__field').attr 'placeholder', 'Search for template'
  #   return
  # $('#cust_sel').on 'select2:close', ->
  #   $('.select2-search__field').attr 'placeholder', null

  $('body').on 'click', '.spinner', (e) ->
    if e.detail == 3
      $(this).removeClass('active')

$(window).load ->
  $.controlMethods.removePlaceholder()
  return
