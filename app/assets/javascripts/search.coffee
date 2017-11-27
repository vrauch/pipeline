# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('body').on 'click', '#cancel-search', ->
    $('#search-form').empty()

  $('body').on 'click', '.advanced-search', (e) ->
    e.preventDefault()
    $('input[name=_method]').remove()
    $.ajax
      type: 'POST'
      url: $(this).attr('href')
      data: $(this).parents('form').serialize()

  $('body').on 'click', '.toggle_search', (e) ->
    e.preventDefault()
    $('.content').removeClass 'content_index'
    $('.top_bar').addClass 'active'
    $('.top_bar .form-control.field_search').focus()
    $(document).mouseup (e) ->
      container = $('.top_bar, .slide-panel, .clear_search_holder')
      if !container.is(e.target) and container.has(e.target).length == 0
        $('.top_bar').removeClass 'active'
        $('.content').addClass 'content_index'


  $('body').on 'click', '.field_search', (e) ->
    $('.search_btns').addClass 'active'
    $(document).mouseup (e) ->
      e.preventDefault()
      container = $('.field_search, .search_btns, .top_bar')
      unless container.is(e.target) || container.has(e.target).length || $('.clear_search_holder').is(":visible")
        $('.search_btns').removeClass 'active'
        $(".clear_search_holder").delay(300).fadeOut('fast')

  $('body').on 'click', '.btn_open_search', (e) ->
    e.preventDefault()
    $.controlMethods.showPanel($(this).data('panel'))
    $.ajax
      type: 'GET'
      url: $(this).attr('href')

  $('body').on 'click', '#save-query-link', (e) ->
    e.preventDefault()
    $(this).parents('form').submit()

  $('body').on 'click', '#save-query-btn', (e) ->
    e.preventDefault()
    $('.btn_save_query').click()
    dest = $(this).attr('href')
    destination = $(dest).offset().top
    $('body, .slide-panel-container').animate({ scrollTop: destination}, 500)

  $('body').on 'click', '#quick-search-btn', (e) ->
    $('#quick-search').submit()

  $('body').on 'submit', '#quick-search', (e) ->
    # $(".clear_search_holder").addClass('active')
    $('.clear_search_holder').delay(300).fadeIn('fast')

  # $('body').on 'click', '.tech-sector-link', (e) ->
  #   $('.search_btns').addClass('active')
  #   $(".clear_search_holder").fadeIn('fast')

  $('body').on 'click', '#clear-quick-search', (e) ->
    e.preventDefault()
    $('.top_bar').nextAll().remove()
    $('.content').append($('#search-restore').html())
    $('#search-restore').remove()
    $('.field_search').val('')
    if $(".clear_search_holder").hasClass('active')
      $(".clear_search_holder").removeClass('active')
    else
      $('.clear_search_holder').delay(300).fadeOut('fast')
    $(".search_btns").removeClass('active')
    $('.top_bar').removeClass('active')


  $('body').on 'click', '#close-save-result', (e) ->
    e.preventDefault()
    content = $('#save-search-restore').children().detach()
    $('.content').html(content)
    $('#save-search-restore').remove()

  $('body').on 'click', '#close-advance-result', (e) ->
    e.preventDefault()
    content = $('#search-restore').children().detach()
    $('.content').html(content)
    $('#search-restore').remove()
    $('.toggle_search').removeClass('hidden')

  $('body').on 'click', '.btn_save_query', (e) ->
    e.preventDefault()
    $(this).parents('.bot_control_btns').find('.hidden_form').fadeIn 'fast'
    $(this).parents('.bot_control_btns').find('.btn_save_query_name').removeClass 'active'

  $('body').on 'click', '.btn_cancel_query_name', (e) ->
    e.preventDefault()
    $(this).parents('.hidden_form').fadeOut 'fast'

  $('body').on 'click', '.collapse_link', (e) ->
    if $(this).hasClass('collapsed')
      $('.number-selected-category', $(this)).html('')
    else
      $.searchMethods.collapsedCategories($(this))

  $('body').on 'click', '.btn_cancel_card', (e) ->
    e.preventDefault()

  $('body').on 'click', '.other-checkbox', (e) ->
    # $(this).parents('.checkbox_list').siblings('.slide_div').stop().slideToggle @checked
    return

  $('body').on 'click', '.save-advanced-query', (e) ->
    e.preventDefault()
    $(this).parents('.top_panel').find('.hidden_form').fadeIn 'fast'
    $(this).parents('.top_panel').find('.btn_save_query_name').removeClass 'active'

  $('body').on 'click', '.submit-save-query', (e) ->
    e.preventDefault()
    $(this).parents('form').submit()

  $('.slide-panel-container').on 'scroll', (e) ->
    $('.calendar').each ->
      $(this).datepicker 'place'

  detectBackSearh()

  $.searchMethods =
    initCalendar: ->
      $('.calendar').datepicker(
        autoclose: true
        orientation: 'top'
        format: 'yyyy-mm-dd').on('changeDate', (e) ->
          $(this).siblings('.icon_calendar').css 'color', '#000'
          if $(this).attr('id') == 'search_added_from'
            $('#search_added_to').datepicker('setStartDate', $(this).val())
          if $(this).attr('id') == 'search_added_to'
            $('#search_added_from').datepicker('setEndDate', $(this).val())
      ).on 'clearDate', (e) ->
        $(this).siblings('.icon_calendar').css 'color', 'rgba(0,0,0,.3)'
       .on 'change', ->
        $('.datepicker').hide()
    initSelect: ->
      $(".chosen-select").chosen({
        disable_search: true
      });
    collapsedCategories: (el) ->
      id = el.attr('href')
      number = parseInt($(id + ' input.category-value:checked').length)
      span = $('.number-selected-category', el).html if number then '(' + number + ')' else ''

  if $('#advanced_search_page').length
    $('.top_bar').first().remove()
    $.searchMethods.initCalendar()
    return

detectBackSearh = ->
  obj = gon.search_back
  if obj
    params = obj.search
    url = '/' + params.controller + '/' + params.action
    delete params.controller
    delete params.action
    delete params.utf8
    delete params.authenticity_token
    if obj.action == 'quick'
      $('.field_search').val(obj.search.search).click()
      $('.clear_search_holder').show()
      $.ajax(
        type: 'POST'
        url: url
        data: params).done ->
          $.ajax(
            type: 'GET'
            url: url
            data: params).done ->
              $('.back-search-loader').remove()
    if obj.action in ['adv', 'adv_filter']
      $.ajax(
        type: 'POST'
        url: '/search/adv'
        data: params).done ->
          if url == '/search/adv_filter'
            $.ajax(
              type: 'GET'
              url: url
              data: params).done ->
                $('.back-search-loader').remove()
          else
            $('.back-search-loader').remove()
  else
    $('.back-search-loader').remove()
