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
    map.on 'moveend', () ->
      if !exports.tableClick
        setLatLng()
        $form.submit()
      exports.tableClick = false
      return
  return

setMapView = (pos) ->
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
  tr.append $('<td>').text(val.prefecture)
  tr.append $('<td>').text(val.name)
  tr.on 'click', ()->
    exports.tableClick = true
    marker.openPopup()
    highlightTableLine(tr)
    return
  marker.on 'click', ()->
    highlightTableLine(tr)
    return
  return tr

noResultTableLine = () ->
  tr = $('<tr>')
  tr.append $('<td>').attr('colspan',2).text("該当データがありませんでした").css("textAlign","center")
  return tr

highlightTableLine = ($dom) ->
  if $dom
    if exports.hilightedDom
      exports.hilightedDom.removeClass("success")
    $dom.addClass("success")
    exports.hilightedDom = $dom
  else
    exports.hilightedDom.removeClass("success")