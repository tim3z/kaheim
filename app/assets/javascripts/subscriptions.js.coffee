$ ->
  # toggle the subscription form in the page-headder
  $('.subscription-toggle-button').click ->
    selector = $(this).data('item-type')
    $('.subscription-toggle.' + selector).toggle()
    $('#subscription-email.' + selector).focus()

  # disabling the subscribe button and enabling the back button if no email is put in
  $('.subscription-email').on 'input', ->
    selector = $(this).data('item-type')
    if ($(this).val())
      $('#subscription-submit-button.' + selector).show()
      $('#subscription-back-button.' + selector).hide()
    else
      $('#subscription-submit-button.' + selector).hide()
      $('#subscription-back-button.' + selector).show()

  # change appearance and text of sign off subscription button on hover
  $('.subscribed-button').hover ->
     $(this).children('.subscribed-button-content').toggle()