$ ->
  $('div[data-link]').click ->
    document.location = $(this).attr('data-link')

  $('button[data-link]').click ->
    document.location = $(this).attr('data-link')

  $('.toggle-collapse').click ->
    $(this).parents('.item').find('div.short').toggle()
    $(this).parents('.item').find('div.long').toggle()

  $('.description').click ->
    $(this).parents('.item').find('.toggle-collapse').click()
