# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  $('body').on 'change', '.send-to', ->
    if $(this).val() == 'selected_u'
      $('.hidden_selected_users').slideDown()
    else
      $('.hidden_selected_users').slideUp()

  $('body').on 'click', '#send-announcement', (e) ->
    e.preventDefault()
    $('#type').val('create')
    $(this).parents('form').submit()

  $('body').on 'click', '.show-hidden-users', (e) ->
    e.preventDefault()
    $(this).siblings('.list_logo_item').removeClass('hidden')
    $(this).hide()


  $('body').on 'change', '.file_upload_cover', ->
    $(this).parent().siblings('.selected_file_name').text $(this)[0].files[0].name
  
  $('body').on 'click', '.btn_remove_file_name', ->
    $(this).siblings('.selected_file_name').empty()
    $('#announcement_cover').val('')
    $('#announcement_cover_cache').val('')

  $('body').on 'click', '#show-preview', (e) ->
    e.preventDefault()
    $('#type').val('preview')
    $(this).parents('form').submit()

  $('body').on 'click', '#announcement-hide-panel', (e) ->
    panel = $(this).parents('.slide-panel')
    panel.removeClass 'is-visible'
    if panel.attr('data-btn') == 'announcements_details'
      $('body').css 'overflow-y', 'auto'

  if $('.ellipsis_text').length
    $('.ellipsis_text').dotdotdot()

  $.mmvMethods = 
    initEditor: ->
      $('a[href="https://froala.com/wysiwyg-editor"]').parent().remove()
      $('.fr-element.fr-view').focus()
      $('.fr-element.fr-view').blur()
