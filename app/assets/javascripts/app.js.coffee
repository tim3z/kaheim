$ ->
  $('.toggle-collapse').click ->
    $(this).parents('.item').find('div.short').toggle()
    $(this).parents('.item').find('div.long').toggle()

  $('[data-behaviour~=datepicker]').datepicker
    autoclose: true,
    format: if $('#locale-selection').data('current-locale') == 'en' then "yyyy-mm-dd" else "dd.mm.yyyy",
    language: if $('#locale-selection').data('current-locale') == 'en' then 'en' else 'de'