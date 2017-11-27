$(document).ready(function() {
  $('body').on('change',  '#startupUploadPDF', function(e){
    $(this).parent().addClass('btn_load');
    $(this).parents('.upload_line').find('.error-message').remove();
    file = $(this).prop('files')[0];
    // Max file size 2MB
    if(file.size/1024/1024 > 2) {
      $(this).parents('.upload_line')
        .prepend('<div class="subtitle error-message">Maximum file size 2MB</div>');
        $(this).parent().removeClass('btn_load');
    } else if(file.name.split('.').pop().toLowerCase() != 'pdf') {
      $(this).parents('.upload_line')
        .prepend('<div class="subtitle error-message">Please select PDF file</div>');
        $(this).parent().removeClass('btn_load');
    }else {
      var files = $(this).prop('files');
      $('#startup_pdf_file').prop('files', files);
      $('#new_startup_pdf').submit();
    }
  });
});
