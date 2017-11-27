(function($) {
  $.fn.imagePreview = function(holder, fit, block_width, block_height) {
    var block_height = block_height || $(this).parent().height();
    var block_width = block_width || $(this).parent().width();
    $(this).on("change", function() {
      var files = !!this.files ? this.files : [];
      if (!files.length || !window.FileReader) return; // no file selected, or no FileReader support
      $(this).parents('.default_upload_file').find(".progress_holder").show();
      if (/^image/.test( files[0].type)){ // only image file
        var reader = new FileReader(); // instance of the FileReader
        reader.readAsDataURL(files[0]); // read the local file

        reader.onload = function() { // set image data as background of div
          if (fit) {
            var per, h, w, margin, styles;
            $(holder).find('img').attr('src', reader.result);
            $(holder).find('img').load( function () {
              var imgWidth = $(this).width(), imgHeight = $(this).height();
              if (imgWidth > imgHeight) {
                per = block_width / imgWidth;
                h = Math.round(imgHeight * per);
                margin = (block_height - h) / 2;
                styles = 'width: 100%; height: auto; margin-top: ' + margin + 'px;';
              } else {
                per = block_height / imgHeight;
                w = Math.round(imgWidth * per);
                margin = (block_width - w) / 2;
                styles = 'width: auto; height: 100%; margin-left: ' + margin + 'px;'
              }
              $(holder).find('img').css(styles);
            });
          } else {
            $(holder).css("background-image", "url("+this.result+")");
          }
        }

        reader.onprogress = function(data) {
          if (data.lengthComputable) {
            var progress = parseInt( ((data.loaded / data.total) * 100), 10 );
            //Progress bar
            $(".progress-bar").width(progress + '%');
            if (progress == 100) {
              $(".progress_holder").hide();
              $("#upload_finish").show();
              $("#upload_finish").fadeOut(200);
            }

          }
        }
      }
    });
  };
})(jQuery);
