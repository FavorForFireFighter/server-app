exports = this
$ ->
  if $('#submit_btn').is(':visible')
    $real_submit = $('input[type=submit]')
    if $real_submit.length != 0
      $real_submit.hide()
      $('#submit_btn').on 'click', (e) ->
        $real_submit.click()
        return
  if $('#back_btn').is(':visible')
    $real_back = $('a.btn-back')
    if $real_back.length != 0
      $real_back.hide()
    $('#back_btn').on 'click', (e) ->
      window.history.back()
      return