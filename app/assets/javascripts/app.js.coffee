$ ->
  # list view details toggle
  $('.toggle-collapse').click ->
    $(this).parents('.item').find('div.short:not(.transition), div.long:not(.transition)').toggle()
    $(this).parents('.item').find('div.short.transition, div.long.transition').slideToggle(300)

  set_short_description_length_indicator = ->
    if (140 - $('.short-description').val().length) >= 0
      $('.short-description').next().html(140 - $('.short-description').val().length)
    else
      $('.short-description').val($('.short-description').val().substr(0, 140))
      $('.short-description').next().html(140)

  # short description sign counter
  $('.short-description').keyup(set_short_description_length_indicator)

  if ($('.short-description').length > 0)
    set_short_description_length_indicator()


  $('[data-behaviour~=datepicker]').datepicker
    autoclose: true,
    format: if $('#locale-selection').data('current-locale') == 'en' then "yyyy-mm-dd" else "dd.mm.yyyy",
    language: if $('#locale-selection').data('current-locale') == 'en' then 'en' else 'de'

  $('.gender-select-item').click ->
    $('#gender-select-button').html($(this).html())
    $('#gender-select-button').append(" <span class='caret'></span>")
    $('#request_gender').val($(this).data('gender'))
    $('#offer_gender').val($(this).data('gender'))

  $('select.select2').select2(allowClear: true)
  $('select.select2').select2("val", $('select.select2').data('value'))

  $('.sort-trigger').click ->
    $('#current-sort-type').text($(this).text())
    $('.sort .sort-item').tsort(order: $(this).data('sort-order'), attr: $(this).data('sort-attr'))

  # toggle the subscription form in the page-headder
  $('.subscription-toggle-button').click ->
    $('.subscription-toggle').toggle()
    $('#subscription-email').focus()

  # disabling the subscribe button and enabling the back button if no email is put in
  $('#subscription-email').on ('input'), ->
    if ($(this).val())
      $('#subscription-submit-button').show()
      $('#subscription-back-button').hide()
    else
      $('#subscription-submit-button').hide()
      $('#subscription-back-button').show()

  # change appearance and text of sign off subscription button on hover
  $('#subscribed-button').hover (event) ->
     $('.subscribed-button-content').toggle()

  $('.group-logo').hover ->
    $('img', this).first().toggle()
    $('img', this).last().toggle()
