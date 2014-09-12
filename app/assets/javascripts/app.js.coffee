$ ->
  #list view details toggle
  $('.toggle-collapse').click ->
    $(this).parents('.item').find('div.short').toggle()
    $(this).parents('.item').find('div.long').toggle()

  #short description sign counter
  $('.short-description').keyup ->
    short_description_length_check()

  short_description_length_check = ->
    if (140 - $('.short-description').val().length) >= 0
      $('.short-description').next().html(140 - $('.short-description').val().length)
    else
      $('.short-description').val($('.short-description').val().substr(0, 140))
      $('.short-description').next().html(140)

  if ($('.short-description').length > 0)
    short_description_length_check()


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

  #toggle the subscription form in the page-headder
  $('.subscription-toggle').click ->
    $('.subscription-form-toggle').toggle()

  #disabling the subscribe button and enabling the back button if no email is put in
  $('#subscription-email').on ('input'), ->
    if ($(this).val())
      $('#subscription-submit-button').show()
      $('#subscription-back-button').hide()
    else
      $('#subscription-submit-button').hide()
      $('#subscription-back-button').show()

  #change appearance and text of sign off subscription button on hover
  $('#subscribed-button').hover (event) ->
     $('.subscribed-button-content').toggle()

  $('#continue', '.combi-form').click ->
    $(this).hide()
    $('#combi-submit').show()
    #ajax and js-logic for showing name and password or two password fields comes here
    #PLACEHOLDER
    $('.name-password-form').show()
