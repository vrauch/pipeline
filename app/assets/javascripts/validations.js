$(document).ready(function(){
  $('body').on('click', '[data-validate-inner] button[type="submit"]', function(e){
    console.log('wqeqwe');
    var validation_cont = $(this).parents('[data-validate-inner]')
    var isValid = true;
    var requiredFilds = $(validation_cont).find('[data-validate-required]');
    $.each(requiredFilds, function(index, field) {
      field = $(field);
      if(field.val().length == 0){
        isValid = false;
        field.parent().addClass('error_field');
        field.parent().append("<span class='error_text'>required</span>");
      } else {
        field.parent().removeClass('error_field');
        field.parent().find('.error_text').remove();
      }
    });
    if(!isValid){
      e.preventDefault();
      e.stopPropagation();
    }
  });
});
