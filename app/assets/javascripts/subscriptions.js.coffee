# toggle the subscription form in the page-headder
$(document).on 'click', '.subscription-toggle-button', ->
  selector = $(this).data('item-type')
  $('.subscription-toggle.' + selector).toggle()
  $('.subscription-email.' + selector).focus()
  $('.subscription-no-spam.' + selector).prop('checked', true)

# disabling the subscribe button and enabling the back button if no email is put in
$(document).on 'input', '.subscription-email', ->
  selector = $(this).data('item-type')
  if ($(this).val())
    $('.subscription-submit-button.' + selector).show()
    $('.subscription-toggle-button.' + selector).hide()
  else
    $('.subscription-submit-button.' + selector).hide()
    $('.subscription-toggle-button.' + selector).show()

# change appearance and text of sign off subscription button on hover
$(document).on 'mouseenter mouseleave', '.subscribed-button', ->
   $(this).children('.subscribed-button-content').toggle()
