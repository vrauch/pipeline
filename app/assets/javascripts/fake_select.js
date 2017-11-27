$(document).ready(function() {
  $('body').on('keyup', '.as_select_simple_search', function(e){
    var searchUrl = $(this).data('search-url');
    searchUrl += '?search=' + $(this).val();
    $.get(searchUrl);
  });

  $('body').on('click', '.as_select_value', function(e){
  	  $(this).parent().toggleClass('active');
  	  $(this).parent().siblings('.as_select').removeClass('active');
      $(this).parents('.as_select').find('.as_select_simple_search').focus();
  	});

  	$('body').on('click', '.tip_item', function(e){
  	  var value = $(this).find('.tip_item_text_large').text();
      var formValue = $(this).data('resource-id');
  	  $(this).parents('.as_select').removeClass('active');
      $(this).parents('.as_select').find('.as_select_value').text(value);
  	  $(this).parents('.as_select').find('.as_select_form_value')
        .val(formValue);
  	  $(this).parents('.as_select').addClass('has_value');
  	});

  	$(document).mouseup(function (e) {
      var container = $(".as_select");
      if (!container.is(e.target)
          && container.has(e.target).length === 0)
      {
        $(".as_select").removeClass('active');
      }
  	});
});
