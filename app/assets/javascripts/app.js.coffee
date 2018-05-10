# show colored version of group logos on hover
$(document).on 'mouseenter mouseleave', '.group-logo', ->
  # first img is black-white
  $('img', this).first().toggle()
  # last (second) img is the colored version
  $('img', this).last().toggle()

# smooth scrolling for hash links
$(document).on 'click', 'a[href*=\\#]:not([href=\\#])', ->
  href = $(this).attr('href')
  id = href.substring(href.indexOf('#'))
  if ($(id).length)
    $('html,body').animate({ scrollTop: $(id).offset().top }, 500)
