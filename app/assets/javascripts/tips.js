$(document).ready(function(){
  $(".show_tip").each(function() {

    $(this).find('.btn_tip_cancel').click(function(e){
      $(this).parents('.show_tip').removeClass('visible');
      $(this).parents('.tip_holder').find('.tip_group_btns').fadeOut(400);

      setTimeout(function(){
        $('.tip_body').css('padding-bottom', '0');
        $(".tip_holder .custom_scroll").mCustomScrollbar("update");
      }, 500);
      e.stopPropagation();
      e.preventDefault();
    });

    $(this).find('.btn_tip_add').click(function(e){
      setTimeout(function(){
        $('.btn_tip_add').addClass('active');
      }, 500);

      setTimeout(function(){
        $('.show_tip').removeClass('visible');
        $('.tip_group_btns').fadeOut(400);
      }, 1500);

      setTimeout(function(){
        $('.tip_body').css('padding-bottom', '0');
        $(".tip_holder .custom_scroll").mCustomScrollbar("update");
      }, 2000);

      e.preventDefault();
    });

    $(this).click(function(e){
      $(this).addClass('visible');
      $(this).find('.btn_tip_add').removeClass('active');
      e.preventDefault();
      // $(this).tooltip('hide');
    });

    $(this).find('.inner-link').click(function(e){
      e.stopPropagation();
    });

    $(this).find('.tip_item').click(function(){
      $(this).parents('.tip_holder').find('.tip_group_btns').fadeIn(400);
      $(this).parents('.tip_holder').find('.tip_body').css('padding-bottom', '51px');
      $(".tip_holder .custom_scroll").mCustomScrollbar("update");
    });

    $(document).mouseup(function (e) {
      var container = $(".tip_holder");
      if (!container.is(e.target)
          && container.has(e.target).length === 0)
      {
        $('.show_tip').removeClass('visible');
      }
    });
  });
  
  $(".custom_scroll").mCustomScrollbar({
    scrollButtons: {
        enable: false,
        advanced: {
          updateOnContentResize: true
        }
    }
  });
});
