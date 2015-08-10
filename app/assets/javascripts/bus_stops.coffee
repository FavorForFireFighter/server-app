# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = this
$ ->
  if $('#bus_stop_list_map').is(':visible')
    map = create_leaflet_map 'bus_stop_list_map'

    exports.drawLayer = L.layerGroup().addTo(map)
    exports.map = map
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition setMapView, setMapView
    else
      setMapView()

    $form = $('#bus_stop_list_form')
    $form.on 'ajax:success', (e, result, status, xhr) ->
      setResult(result)
      return
    $form.on 'ajax:error', () ->
      clearData()
      $('#stop_list').append noResultTableLine()
      return
    $form.on 'ajax:complete', ()->
      return
    map.on 'moveend', () ->
      if !exports.tableClick
        setLatLng()
        $form.submit()
      exports.tableClick = false
      return

  if $('#bus_stop_show_map').is(':visible')
    map = create_leaflet_map 'bus_stop_show_map'
    latitude = $('#bus_stop_latitude').data('location')
    longitude = $('#bus_stop_longitude').data('location')
    L.marker([latitude, longitude]).addTo(map)
    map.fitBounds([[latitude, longitude], [latitude, longitude]])

  if $('#bus_stop_new_map').is(':visible')
    exports.map = create_leaflet_map 'bus_stop_new_map'
    setMarker()
    $('#bus_stop_prefecture_id').on 'change', (e) ->
      id = $(e.currentTarget).val()
      $prefecture_location = $('#prefecture_location_' + id)
      setMarker($prefecture_location.data('latitude'), $prefecture_location.data('longitude'))
      getMapCenter()
      $('#location_updated_at').val("false")

    $('#get_current_position').on 'click', (e) ->
      e.preventDefault()
      if navigator.geolocation
        setMarkerByCurrentPosition()
      else
        alert("現在地を取得できませんでした")
      return
    $('.route_delete').on 'click', (e) ->
      $(e.currentTarget).parent().remove()
      return

    setListenersOfRouteInformationInputs()

  return

##
# index
##
setMapView = (pos) ->
  latitude = $('#latitude').val()
  longitude = $('#longitude').val()
  if latitude.length == 0 || longitude.length == 0
    pos = pos || {}
    crd = pos.coords
    if crd
      longitude = crd.longitude
      latitude = crd.latitude
    else
      longitude = 139.766865
      latitude = 35.681109
  exports.map.setView [latitude, longitude], 10
  return

setLatLng = () ->
  center = exports.map.getCenter()
  $('#latitude').val(center.lat)
  $('#longitude').val(center.lng)
  return

searchBusStops = () ->
  center = exports.map.getCenter()
  data = {latitude: center.lat, longitude: center.lng}
  $.ajax({
    url: "/api/bus_stops/list",
    data: data,
    dataType: 'json',
    method: 'get'
  }).done(setResult).fail(clearData)

clearData = () ->
  exports.drawLayer.clearLayers()
  $('#stop_list').empty()
  return

setResult = (data) ->
  clearData()
  trs = []
  for val in data
    marker = addMarker(val.latitude, val.longitude, val.name)
    trs.push createTableLine(val, marker)
  $('#stop_list').append(trs)
  return

addMarker = (latitude, longitude, name) ->
  return L.marker([latitude, longitude]).bindPopup(name).addTo(exports.drawLayer)

createTableLine = (val, marker) ->
  tr = $('<tr>')
  tr.append $('<td>').text(val.name).addClass("stop_name")
  tr.append createActionButtons(val.id).addClass("action")
  tr.on 'click', (e)->
    exports.tableClick = true
    marker.openPopup()
    highlightTableLine(tr)
    return
  marker.on 'click', ()->
    highlightTableLine(tr)
    return
  return tr

createActionButtons = (id) ->
  $show = $('<a>').addClass("btn btn-default").attr("href", "/bus_stops/" + id).text("詳細")
  return $('<td>').append($show)

noResultTableLine = () ->
  tr = $('<tr>')
  tr.append $('<td>').attr('colspan', 2).text("該当データがありませんでした").css("textAlign", "center")
  return tr

highlightTableLine = ($dom) ->
  if $dom
    if exports.hilightedDom
      exports.hilightedDom.removeClass("success")
    $dom.addClass("success")
    exports.hilightedDom = $dom
  else
    exports.hilightedDom.removeClass("success")

##
# new
##
setMarker = (lat, lng) ->
  if typeof lat is 'undefined' and typeof lng is 'undefined'
    lat = $('#latitude').val()
    lng = $('#longitude').val()

  if lat is "" or lng is ""
    if navigator.geolocation
      setMarkerByCurrentPosition()
      return
    else
      lat = 35.681109
      lng = 139.766865

  if exports.marker
    exports.marker.setLatLng [lat, lng]
  else
    marker = L.marker([lat, lng], {draggable: true}).addTo(exports.map)
    marker.on 'dragend', (e)->
      getMapCenter()
      markerMoved()
    exports.marker = marker
  getMapCenter()
  exports.map.setView([lat, lng], 15)
  return

setMarkerByCurrentPosition = (err) ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition((pos) ->
      crd = pos.coords
      if crd
        longitude = crd.longitude
        latitude = crd.latitude
        setMarker(latitude, longitude)
        markerMoved()
      return
    , () ->
      alert("現在地を取得できませんでした")
      setMarker(35.681109, 139.766865)
    )
  else
    err()
  return

getMapCenter = () ->
  center = exports.marker.getLatLng()
  $('#latitude').val(center.lat)
  $('#longitude').val(center.lng)
  return

markerMoved = () ->
  $('#location_updated_at').val('true')
  return

disabled = ($dom, disabled) ->
  $dom.prop('disabled', disabled)
  return

addToSelector = ($selector, key, val) ->
  _val = val || $selector.children().length * -1
  option = $('<option>').text(key).val(_val)
  $selector.append(option)
  if _val < 0
    $selector.val(_val).trigger('change')
  return

addToRouteInformation = (company, company_id, line, line_id) ->
  tr = $('<tr>')
  delete_button = $('<td>').append($('<span>').addClass("glyphicon glyphicon-remove").attr("aria-hidden",
    true)).addClass("route_delete")
  delete_button.on 'click', (e) ->
    $(e.currentTarget).parent().remove()
    return
  tr.append delete_button
  tr.append $('<td>').text(company)
  tr.append $('<td>').text(line)
  tr.append $('<input>').val(line_id).attr({name: 'bus_route_information[id][]', type: 'hidden'})
  $('#route_informations').append tr
  return

resetRouteInformationInputs = () ->
  $('#route_information_inputs').find('input').each (index, dom) ->
    $dom = $(dom)
    $dom.val("")
  $('#route_information_inputs').find('.has-error').each (index, dom) ->
    $(dom).removeClass('has-error')
  $('[name=bus_type_id]').each (index, dom) ->
    disabled($(dom), true)
  resetSelector($('#bus_operation_company_id'))
  resetSelector($('#bus_route_information_id'))
  return

resetSelector = ($selector) ->
  prompt = $selector.children(':first')
  $selector.empty().append(prompt)
  $selector.val("")
  $selector.trigger "change"
  return

hasError = ($input, val) ->
  if val is "" || val is null
    $input.parents('.form-group').addClass("has-error")
    return true
  else
    $input.parents('.form-group').removeClass("has-error")
    return false

setListenersOfRouteInformationInputs = () ->
  $addRoute_information_inputs = $('#route_information_inputs')
  $bus_operation_company_selector = $('#bus_operation_company_id')
  $bus_route_information_selector = $('#bus_route_information_id')

  $('#add_route_information').on 'click', (e) ->
    $addRoute_information_inputs.removeClass('hide')
    return

  $('#add_route_cancel').on 'click', (e) ->
    e.preventDefault()
    $addRoute_information_inputs.addClass('hide')
    resetRouteInformationInputs()
    return

  $('#add_route').on 'click', (e) ->
    e.preventDefault()
    company_id = $bus_operation_company_selector.val()
    company_name = $bus_operation_company_selector.find(':selected').text()
    line_id = $bus_route_information_selector.val()
    line_name = $bus_route_information_selector.find(':selected').text()
    if !hasError($bus_operation_company_selector, company_id) && !hasError($bus_route_information_selector, line_id)
      if company_id < 0 || line_id < 0
        type_id = $('[name=bus_type_id]:checked').val()
        data = {
          company_id: company_id,
          company_name: company_name,
          line_id: line_id,
          line_name: line_name,
          type_id: type_id
        }
        ajax = $.ajax({
          url: "/api/bus_routes/register",
          data: data,
          method: 'post'
        })
        ajax.done (result) ->
          if result.success
            addToRouteInformation(company_name, result.company_id, line_name, result.line_id)
            $bus_operation_company_selector.find(':selected').val(result.company_id)
            $bus_route_information_selector.find(':selected').val(result.line_id)
            $('[name=bus_type_id]').each (index, dom) ->
              disabled($(dom), true)
            $addRoute_information_inputs.addClass('hide')
          else
            alert("バス運営会社または路線の追加を行えませんでした")
        ajax.fail () ->
          alert("バス運営会社または路線の追加を行えませんでした")
      else
        addToRouteInformation(company_name, company_id, line_name, line_id)
        $addRoute_information_inputs.addClass('hide')
    $('#route_information_inputs').find('.has-error').each (index, dom) ->
      $(dom).removeClass('has-error')
    return

  $('#search_company').on 'click', (e) ->
    e.preventDefault()
    $input = $('#search_company_name')
    company = $input.val()
    if !hasError($input, company)
      ajax = $.ajax({
        url: "/api/bus_routes/companies",
        data: {name: company}
      })
      ajax.done (data) ->
        resetSelector($bus_operation_company_selector)
        resetSelector($bus_route_information_selector)
        for val in data
          addToSelector($bus_operation_company_selector, val.name, val.id)
        return
      ajax.fail (data) ->
        resetSelector($bus_operation_company_selector)
        resetSelector($bus_route_information_selector)
        return
    return

  $('#add_company').on 'click', (e) ->
    e.preventDefault()
    $input = $('#bus_operation_company_name')
    company = $input.val()
    if !hasError($input, company)
      addToSelector($bus_operation_company_selector, company)
    return

  $('#add_line').on 'click', (e) ->
    e.preventDefault()
    $input = $('#bus_route_line_name')
    line = $input.val()
    if !hasError($input, line)
      addToSelector($bus_route_information_selector, line)
    return

  $bus_operation_company_selector.on 'change', (e) ->
    val = $(e.currentTarget).val()
    if val > 0
      ajax = $.ajax({
        url: "/api/bus_routes/lines",
        data: {company_id: val}
      })
      ajax.done (data) ->
        for val in data
          addToSelector($bus_route_information_selector, val.name, val.id)
        return

    resetSelector($bus_route_information_selector)
    return

  $bus_route_information_selector.on 'change', (e) ->
    val = $(e.currentTarget).val()
    $('[name=bus_type_id]').each (index, dom) ->
      disabled($(dom), val == "" || val > 0)
    return
  return