# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#slide_counter').prepend '<span class="current-index"></span>/'
  slider = $('.questions_slider').bxSlider(
    mode: 'fade',
    speed: 0
    touchEnabled: false
    onSliderLoad: (currentIndex) ->
      $('#slide_counter .current-index').text currentIndex + 1
      return
    onSlideBefore: ($slideElement, oldIndex, newIndex) ->
      $('#slide_counter .current-index').text newIndex + 1
      $('.question_text, .question_title').addClass 'fadeIn'
      $('.btn_question').addClass 'animated fadeIn'
      return
    onSlideAfter: ->
      $('.question_text, .question_title').addClass 'fadeIn'
      $('.btn_question').addClass 'fadeIn'
      return
  )
  if $('#slide_counter').length
    $('#slide_counter').append slider.getSlideCount()

  $('.btn_question').click (e) ->
    unless $(this).data('last-index') == true
      slider.goToNextSlide()
      $('html, body').animate { scrollTop: 0 }, 'slow'
    return

  $('input:radio').change ->
    if $(this).parents(".btn_question").data('last-index') == true
      $("#new_user_diagnostic_summary").submit()
    return

  (new WOW()).init()

$(window).resize ->
  # $('.accordion_holder .panel-group .panel').each ->
  #   name_date
  #   if window.matchMedia('(max-width: 767px)').matches
  #     name_date = $(this).find('.panel_info_name_date').detach()
  #     $(this).append name_date
  #   else
  #     name_date = $(this).find('.panel_info_name_date').detach()
  #     $(this).find('.panel_info').append name_date

  if $('.sidebar_detail_body').length
    minHeightDetailBody = $('.sidebar_detail_body').outerHeight()
    minHeightContainer = $('.page_container').outerHeight()
    if window.matchMedia('(max-width: 767px)').matches and minHeightDetailBody < minHeightContainer
      $('.page_container').css 'overflow-y', 'hidden'
    else
      $('.sidebar_detail_body').addClass 'hidden_before'
  return