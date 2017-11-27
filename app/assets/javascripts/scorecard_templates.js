$(document).ready(function(){
  $('body').on('change', '#scorecard_template_logo', function() {
    action = $('#scorecard_template_form').attr('action');
    refreshAction = $('#scorecard_template_form').data('refresh');
    $('#scorecard_template_form').attr('action', refreshAction).submit();
    $('#scorecard_template_form').attr('action', action);
  });

  $('body').on('click', '.control_question', function(e){
    e.preventDefault();
    $(this).parents('.question-cont').find('.checkbox-cont').addClass('hidden');
    $(this).parents('.question-cont').find('.edit_question_block').removeClass('hidden');
  });

  $('body').on('click', '.edit_question_block .btn-cancel', function(e){
    var parent = $(this).parents('.question-cont');
    var inputs = parent.find('.edit_question_block input[type="text"]');
    $.each(inputs, function(index, input) {
      var input = $(input);
      input.val(input.data('default-val'));
    });
    parent.find('.checkbox-cont').removeClass('hidden');
    parent.find('.edit_question_block').addClass('hidden');
  });

  $('body').on('click', '.edit_question_block .btn-save', function(e){
    var parent = $(this).parents('.question-cont');
    var inputs = parent.find('.edit_question_block input[type="text"]');
    $.each(inputs, function(index, input) {
      var input = $(input);
      console.log(input.data('input-for'));
      parent.find(input.data('input-for')).text(input.val());
      input.data('default-val', input.val());
    });
    parent.find('.checkbox-cont').removeClass('hidden');
    parent.find('.edit_question_block').addClass('hidden');
  });

  $('body').on('change', '.ls_product_section_types input:radio', function(e){
    var value = parseInt($(this).val());
    var rs_value = parseInt($('.rs_product_section_types input:radio:checked').val());
    if(value == rs_value) {
      if(value == 0) {
        $('.rs_product_section_types input:radio[value="1"]').prop('checked', true);
      } else if(value == 1) {
        $('.rs_product_section_types input:radio[value="0"]').prop('checked', true);
      }
    }
  });

  $('body').on('change', '.rs_product_section_types input:radio', function(e){
    var value = parseInt($(this).val());
    var ls_value = parseInt($('.ls_product_section_types input:radio:checked').val());
    if(value == ls_value) {
      if(value == 0) {
        $('.ls_product_section_types input:radio[value="1"]').prop('checked', true);
      } else if(value == 1) {
        $('.ls_product_section_types input:radio[value="0"]').prop('checked', true);
      }
    }
  });

  // disable checkboxes if checked 5
  $('body').on('change', '.business_questions input:checkbox', function(e){
    if($('.business_questions input:checkbox:checked').length > 5) {
      $(this).prop('checked', false);
    }
  });
});
