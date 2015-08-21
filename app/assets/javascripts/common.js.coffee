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

  $('#pager').on 'ajax:success', (e, result, status, xhr)->
    $('#pager').html result.paginator
    $('#pager').find('a').each (index,dom)->
      href = dom.href
      if href isnt "" and href.indexOf("page=") is -1
        if href.indexOf("?") is -1
          dom.href = href + "?page=1"
        else
          dom.href = href + "&page=1"
      return
    $('#list').html result.list
    $page = $('#page')
    if $page
      $page.val result.page
    return
  return
##
# Global functions
##
exports.create_leaflet_map = (map_id) ->
  map = L.map map_id
  L.tileLayer('http://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png', {
    attribution: "<a href='http://www.gsi.go.jp/kikakuchousei/kikakuchousei40182.html' target='_blank'>国土地理院</a>"
  }).addTo(map);
  L.control.scale({imperial:false}).addTo(map);
  return map

##
# Local functions
##

# bus_stop#index
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
  path = "bus_stops/"
  if location.pathname.indexOf("bus_stops/") isnt -1
    path = ""
  $show = $('<a>').addClass("btn btn-default").attr("href", path + id).text("詳細")
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