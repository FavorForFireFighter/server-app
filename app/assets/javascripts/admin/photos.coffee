# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $page_link = $('#page_link')
  link_id = $page_link.val()
  if link_id
    $a = $("#" + link_id)
    if $a.length > 0
      $a.trigger('click')

  $('#pager').on 'click', (e) ->
    if e.target.tagName is "A"
      href = e.target.href
      if href
        $page_link.val e.target.id
    return
  return