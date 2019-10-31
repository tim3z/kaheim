# list view details toggle
$(document).on 'click', '.toggle-collapse', ->
  $(this).parents('.item').find('div.short:not(.transition), div.long:not(.transition)').toggle()
  $(this).parents('.item').find('div.short.transition, div.long.transition').slideToggle(300)

$(document).on 'click', '.gender-select-item', (event) ->
  $('#gender-select-button').html($(this).html())
  $('#gender-select-button').append(" <span class='caret'></span>")
  $('#request_gender').val($(this).data('gender'))
  $('#offer_gender').val($(this).data('gender'))
  event.preventDefault()

# item sorting
$(document).on 'click', '.sort-trigger', (event) ->
  $('#current-sort-type').text($(this).text())
  $('.sort .sort-item').tsort(order: $(this).data('sort-order'), attr: $(this).data('sort-attr'))
  event.preventDefault()

document.addEventListener "turbolinks:load", ->
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

  # district select
  $('select.select2').select2(allowClear: true)

  $('.request-edit-link').each ->
    item_id = $(this).data('id')
    item_type = $(this).data('type')
    token = localStorage.getItem(item_type + '-' + item_id)
    if (token)
      inline_button = $(this).find('.inline-button')
      inline_button.removeClass('toggle-collapse')
      inline_button.on 'click', (event) ->
        Turbolinks.visit("/#{item_type}s/#{item_id}/owner_show?token=#{token}")


@store_owner_token = (item_id, item_type) ->
  urlParams = new URLSearchParams(window.location.search)
  token = urlParams.get('token')
  if (token)
    localStorage.setItem(item_type + '-' + item_id, token)
