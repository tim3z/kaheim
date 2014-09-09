$ ->
  #list view details toggle
  $('.toggle-collapse').click ->
    $(this).parents('.item').find('div.short').toggle()
    $(this).parents('.item').find('div.long').toggle()

  #short description sign counter
  $('.short-description').keyup ->
    if (140 - $('.short-description').val().length) >= 0
      $('.short-description').next().html(140 - $('.short-description').val().length)
    else
      $('.short-description').val($('.short-description').val().substr(0, 140))

  $('[data-behaviour~=datepicker]').datepicker
    autoclose: true,
    format: if $('#locale-selection').data('current-locale') == 'en' then "yyyy-mm-dd" else "dd.mm.yyyy",
    language: if $('#locale-selection').data('current-locale') == 'en' then 'en' else 'de'

  $('.gender-select-item').click ->
    $('#gender-select-button').html($(this).html())
    $('#gender-select-button').append(" <span class='caret'></span>")
    $('#request_gender').val($(this).data('gender'))

  $('select.select2').select2(allowClear: true)
  $('select.select2').select2("val", $('select.select2').data('value'))

  $('.sort-trigger').click ->
    $('.sort .sort-item').tsort(order: $(this).data('sort-order'), attr: $(this).data('sort-attr'))

  $('.subscription-toggle').click ->
    $('.subscription-form-toggle').toggle()

  $('#subscription-email').keyup ->
    if ($(this).val())
      $('#subscription-submit-button').show()
      $('#subscription-back-button').hide()
    else
      $('#subscription-submit-button').hide()
      $('#subscription-back-button').show()

