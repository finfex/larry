# Пример клика по строке app/assets/javascripts/shared/row_href.coffee

document.addEventListener "turbolinks:load", ->
  $('[data-href]').click (e) ->
    url = $(this).data('href')
    window.location = url
