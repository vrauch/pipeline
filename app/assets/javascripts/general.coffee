$(document).ready ->
  $('.custom_dropdown').hover (->
    $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn 300
    return
  ), ->
  $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut 300
  return