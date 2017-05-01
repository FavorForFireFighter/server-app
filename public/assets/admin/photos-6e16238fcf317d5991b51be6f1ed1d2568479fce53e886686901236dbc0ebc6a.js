(function() {
  $(function() {
    var $search_form;
    $('#collapse-link').on('click', function(e) {
      var $icon;
      $icon = $('#collapse-icon');
      if ($icon.hasClass('glyphicon-collapse-up')) {
        $icon.addClass('glyphicon-collapse-down').removeClass('glyphicon-collapse-up');
      } else {
        $icon.addClass('glyphicon-collapse-up').removeClass('glyphicon-collapse-down');
      }
    });
    $search_form = $('#photo_search_form');
    $search_form.on('ajax:success', function(e, result, status, xhr) {
      $('#pager').html(result.paginator);
      $('#list').html(result.list);
      $('#page').val(result.page);
    });
    $('#photo_search_btn').on('click', function(e) {
      $('#page').val(1);
    });
    return $search_form.trigger('submit');
  });

}).call(this);
