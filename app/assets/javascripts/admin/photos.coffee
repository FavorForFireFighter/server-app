# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

  $('#collapse-link').on 'click', (e) ->
    $icon = $('#collapse-icon')
    if $icon.hasClass('glyphicon-collapse-up')
      $icon.addClass('glyphicon-collapse-down').removeClass('glyphicon-collapse-up')
    else
      $icon.addClass('glyphicon-collapse-up').removeClass('glyphicon-collapse-down')
    return

  $search_form = $('#photo_search_form')
  $search_form.on 'ajax:success', (e, result, status, xhr)->
    $('#pager').html result.paginator
    $('#list').html result.list
    $('#page').val result.page
    return

  $('#photo_search_btn').on 'click', (e) ->
    $('#page').val 1
    return

  $search_form.trigger 'submit'