// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery.previewimage
//= require jquery.image_preview
//= require cocoon
//= require select2
//= require jquery-ui/sortable
//= require lists_change_position
//= require_tree .
//= require bootstrap.min
//= require jquery.mCustomScrollbar.concat.min
//= require outdatedBrowser.min
//= require fileinput.min
//= require jquery.bxslider.min
//= require chosen.jquery.min
//= require bootstrap-datepicker
//= require jquery.scrollTo
//= require highcharts-custom
//= require tagmanager
//= require typeahead.bundle
//= require bloodhound.min
//= require wow
//= require froala_editor.min.js
//= require plugins/image.min.js
//= require plugins/image_manager.min.js
//= require plugins/link.min.js
//= require chosenImage.jquery
//= require jquery.dotdotdot.min
//= require select2.full.min

function ap(params) {
  console.log(params)
}

function minHeightSidebarBody(){
  if ($('.sidebar_detail_body').length) {
    var minHeightDetailBody = $('.sidebar_detail_body').outerHeight();
    var minHeightContainer = $('.page_container').outerHeight();
    if ((window.matchMedia("(max-width: 767px)").matches)&&(minHeightDetailBody<minHeightContainer)) {
      $('.page_container').css('overflow-y', 'hidden');
    } else {
      $('.sidebar_detail_body').addClass('hidden_before');
    }
  }
}

function curvedLines(){
  if ($('.curved_lines').length) {
    if (window.matchMedia("(max-width: 1199px)").matches) {
      var emptyText = $('.empty_block i');
    } else {
      var emptyText = $('.empty_title_inner');
    }
    var bottom = ($('.page_container > [class^=content]').outerHeight() - (emptyText.offset().top + emptyText.outerHeight()));
    var right = ($(window).width() - (emptyText.offset().left + emptyText.outerWidth()));
    var leftPosLine = $('.page_container > [class^=content]').outerWidth() - right;
    $('.curved_lines').css({"left": leftPosLine, "bottom": bottom});
  }
}

function hoverDropdown(){
  if ($(window).width() > 991) {
    $('.custom_dropdown').hover(function() {
      $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeIn(300);
      $(this).find('.dropdown-toggle .icon_arrow_down').css('transform', 'rotate(-180deg)');

    }, function() {
      $(this).find('.dropdown-menu').stop(true, true).delay(100).fadeOut(300);
      $(this).find('.dropdown-toggle .icon_arrow_down').css('transform', 'rotate(0)');
    });
  }
}

$( document ).ready(function() {
  minHeightSidebarBody();
  curvedLines();
  hoverDropdown();
});

$( window ).resize(function() {
  minHeightSidebarBody();
  curvedLines();
  hoverDropdown();
});
