import 'sticky-table-headers/js/jquery.stickytableheaders.min.js'

document.addEventListener("turbolinks:load", function() {
  $('table[data-sticky]').stickyTableHeaders({
    cacheHeaderHeight: true,
    fixedOffset: $('.sticky-top')
  })
});
