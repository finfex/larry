//= require best_in_place
//= require best_in_place.jquery-ui
//= require turbolinks
//= require cocoon
//= require_tree .
//= require_self

document.addEventListener("turbolinks:load", function() {
  $('.rate-popover').on('shown.bs.popover', function () {
    $tip = $(this).data('bs.popover').$tip
    $tip.attr('style', '')
    $tip.addClass('popover-bottom-fixed')
  })
});
