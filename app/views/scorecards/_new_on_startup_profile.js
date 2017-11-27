if($('.list_holder').length == 0) {
  $('.slide-panel-container').addClass('full_width');
  $('.bot_control_btns').addClass('full_width');
}

if($('.top_menu.fixed_menu').length > 0) {
  $('#slidePanel').css('z-index', 1000);
}
