$(document).ready(function(){
  $('body').on('change', '.sc_questions_list input[type="radio"]', function(e) {
    var totalScore = 0;
    var parent = $(this).parents('.sc_questions_list');
    $.each(
      parent.find('input[type="radio"]:checked'), function(index, el){
        totalScore += parseInt($(el).data('score'));
      }
    );
    parent.find('.sc_total_score').text(totalScore);
  });

  $('body').on('change', '#scorecard_logo, #scorecard_product_image, #scorecard_rs_product_image', function() {
    $('.spinner').addClass('active');
    action = $('#scorecard_form').attr('action');
    refreshAction = $('#scorecard_form').data('refresh');
    $('#scorecard_form').attr('action', refreshAction).submit();
    $('#scorecard_form').attr('action', action);
  });

  $('body').on('click', '.btn_tip_add', function(e){
    $(this).parents('.tip_holder').find('#new_brand_scorecard').submit();
  });

  $('body').on('click', '.btn_tip_add', function(e){
    $(this).parents('.tip_holder').find('.add_form').submit();
  });

  $('body').on('mouseleave', '.scorecard_card', function(e){
    $(this).find('.card_middle_btn_item').removeClass('visible');
  });

  $( ".sortable-scorecards" ).sortable({
	  axis: 'y',
	  containment: "parent"
	}).disableSelection();
});

// function graph(pqc, ccs, xGraph){
// 	if ($('.custom_graph').length) {
// 		var heightGraph = $('.custom_graph').outerHeight();
// 		var widthGraph = $('.custom_graph').outerWidth();
// 		var yGraph = (pqc * 1.5) + ccs;
// 		var yPosPoint = (heightGraph/25)*yGraph;
// 		var xPosPoint = (widthGraph/10)*xGraph;
// 		($('.graph_point')).css({"left": xPosPoint, "bottom": yPosPoint});
// 	}
// }
