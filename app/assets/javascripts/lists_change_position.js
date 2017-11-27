$(document).ready(function() {
  function setPositions() {
    $('.list-item').each(function(i) {
      $(this).attr('data-pos', i+1);
    });
  }

  function getNewPositions() {
    var newPositions = [];
     $('.list-item').each(function(i) {
      newPositions.push({
        id: $(this).attr('data-id'),
        position: $(this).attr('data-pos')
      });
    });
    return newPositions;
  }

  // init
  setPositions();

  $('.sortable').sortable({
      placeholder: 'sortable-placeholder',
      revert: 200
    }).bind('sortupdate', function(e, target) {
      $('.spinner').addClass('active');
      setPositions();
      $.ajax({
        url: $('.sortable').data('sort-url'),
        type: 'PUT',
        data: { order: getNewPositions() }
      });
  });
});
