# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('.btn_done').on 'click', ->

    progressStep = $(this).parents(".panel-body").data("progress-step")
    $(".bordered_menu li").removeClass("active")
    $(".bordered_menu li:eq(" + progressStep + ")").addClass("active")

    currentPanel = $(this).closest('div.panel.panel-default')
    nextPanel = currentPanel.next()
    $(currentPanel).addClass 'visited'
    if $(nextPanel).hasClass('hidden_item')
      $(nextPanel).removeClass 'hidden_item'
      $(nextPanel).find('.panel-title a').click()
    else
      $(nextPanel).find('.panel-title a').click()
    false
  $('body').on 'click', '.hidden_item a[data-toggle="collapse"]', (e) ->
    e.stopPropagation()
    return


  $("body").on "click", ".checkbox-answer:not(.active)", (e) ->
    checkGroup = $(this).parents(".checkbox-group")
    checkUpTo = checkGroup.data('up-to')
    return unless checkUpTo
    active = checkGroup.find("input").filter(":checked")
    if active.length >= checkUpTo
      $(this).removeAttr("checked");
      e.stopPropagation()
      e.preventDefault()
    return

#  if $('.accordion_wizard').length > 0
#    $('html, body').animate { scrollTop: $('.collapse.in').offset().top - 100 }, 500

  $('.accordion_wizard').on 'shown.bs.collapse', ->
    $('html, body').animate { scrollTop: $('.collapse.in').offset().top - 100 }, 500