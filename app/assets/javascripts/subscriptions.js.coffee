$ ->
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