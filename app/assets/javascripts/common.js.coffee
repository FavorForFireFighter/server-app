exports = this
current = {}
$ ->
  if $('#bus_stop_list_map').is(':visible')
    $form = $('#bus_stop_list_form')

    map = create_leaflet_map 'bus_stop_list_map'
    exports.loadTimeDimension(map)
    current.drawLayer = L.layerGroup().addTo(map)
    current.map = map
    latitude = $('#latitude').val()
    longitude = $('#longitude').val()
    if exports.isBlank(latitude) || exports.isBlank(longitude)
      exports.initMap map
      $form.trigger 'submit'
      #if navigator.geolocation
        #navigator.geolocation.getCurrentPosition setCurrentPosition, exports.cantGetPosition
    else
      exports.initMap map, latitude, longitude, $('#zoom').val()
      $form.trigger 'submit'

    $form.on 'ajax:success', (e, result, status, xhr) ->
      setResult(result)
      return
    $form.on 'ajax:error', () ->
      clearData()
      $('#stop_list').append noResultTableLine()
      return
    $form.one 'ajax:complete', () ->
      id = $('#selected_id').val()
      $('#selected_id').val("")
      if id
        selected = $('#' + id)
        selected.trigger 'click'
        exports.scrollToDom selected, 'bus_stop_list_list'
      return
    map.on 'moveend', () ->
      setLatLng()
      if current.doSearch
        $form.submit()
      current.doSearch = true
      return
    current.doSearch = true

  if $('#bus_stop_show_map').is(':visible')
    map = create_leaflet_map 'bus_stop_show_map'
    latitude = $('#bus_stop_latitude').data('location')
    longitude = $('#bus_stop_longitude').data('location')
    fire_status = $('#bus_stop_status').data('status')
    marker = L.marker([latitude, longitude], {icon: selectIcon(fire_status)}).addTo(map)
    map.setView marker.getLatLng(), map.getMaxZoom()

  $('#pager').on 'ajax:success', (e, result, status, xhr)->
    $('#pager').html result.paginator
    $('#pager').find('a').each (index, dom)->
      href = dom.href
      if exports.isBlank(href) and href.indexOf("page=") is -1
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
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 20,
    minZoom: 2,
    id: 'mapbox.emerald',
    accessToken: 'pk.eyJ1IjoidW9rdW11cmEiLCJhIjoiY2oyMzl1eGd5MDAwdjMzbGxwNGZoaWplaCJ9.PKXmdbEBSwShnDD3ZIMKkw',
    }).addTo(map);
  L.control.scale({imperial: false}).addTo(map);
  return map

exports.initMap = (map, lat, lng, zoom) ->
  if exports.isBlank(lat) || exports.isBlank(lng)
    lat = 20
    lng = 101
  zoom = if exports.isBlank zoom then 10 else zoom
  map.setView [lat, lng], zoom
  #createHeatmapLayerInto(map).loadData("/data/fire.json");
  createWindLayerInto(map).loadData('/data/fire.json', "/data/wind.json");
  return

exports.fireIcon_found = L.icon(
  iconUrl: '/images/fire.png'
  iconSize: [
    32
    32
  ]
  iconAnchor: [
    22
    22
  ]
  popupAnchor: [
    -3
    -20
  ])

exports.fireIcon_gone = L.icon(
  iconUrl: '/images/fire_gone.png'
  iconSize: [
    32
    32
  ]
  iconAnchor: [
    22
    22
  ]
  popupAnchor: [
    -3
    -20
  ])


exports.isBlank = (val)->
  if typeof val is 'undefined' || val is null
    return true
  if val.length is 0
    return true
  if typeof  val is 'object' && val is {}
    return true
  return false

exports.cantGetPosition = () ->
  alert("現在地を取得できませんでした")

exports.highlightTableLine = ($dom, $predom) ->
  if $predom
    $predom.removeClass("success")
  if $dom
    $dom.addClass("success")

exports.scrollToDom = ($dom, scroll_area_id) ->
  list = document.getElementById(scroll_area_id)
  offset = $dom.offset()
  list.scrollTop = offset.top - list.offsetTop + list.scrollTop - (list.clientHeight / 2 - 50)
  return

exports.newHeatmapLayerInto = () ->
  return new HeatmapOverlay(cfg =
    radius: 0.01
    maxOpacity: 400
    minOpacity: 300
    scaleRadius: true
    useLocalExtrema: true
    gradient:
      0.1: '#900'
      0.25: '#f96'
      0.5: '#fd9'
      0.75: '#ffd'
      1: 'white'
  )

# create window layer
createWindLayerInto = (map) ->
  svgLayer = d3.select(map.getPanes().overlayPane).append('svg')
  svgLayer.attr 'class', 'leaflet-zoom-hide fill'
  plotLayer = svgLayer.append('g')
  {
    svgLayer: svgLayer
    plotLayer: plotLayer
    loadData: (fireData, windData) ->
      $.getJSON windData, (wind) ->
        $.getJSON fireData, (data) ->
          data.forEach (fire) ->
            pos = map.latLngToLayerPoint(new (L.LatLng)(fire.lat, fire.lng))
            interval = if fire.value > 400 then 10 else if fire.value > 300 then 4000 - (fire.value * 10) else 1000
            size = 10
            rect =
              left: pos.x - size
              top: pos.y - size
              right: pos.x + size
              bottom: pos.y + size
            # 風速: ダミー
            windDir = wind[0].data[(90 - Math.round(fire.lat)) * 360 + Math.round(fire.lng)]
            v =
              x: Math.cos(windDir * Math.PI / 180) * 50
              y: Math.sin(windDir * Math.PI / 180) * 50
            setInterval (->
              putParticle svgLayer, d3.randomUniform(rect.left, rect.right), d3.randomUniform(rect.top, rect.bottom), v.x, v.y
              return
            ), interval
            return
          return
        return
      return
  }

putParticle = (svgLayer, x, y, vx, vy) ->
  circle = svgLayer.append('circle').attr('cx', x).attr('cy', y).attr('r', 2).attr('fill', '#ffb').attr("stroke", "#fb9").attr('class', 'particle')
  circle.transition().duration(1000).ease(d3.easeLinear).attr('transform', 'translate(' + vx + ',' + vy + ')').on 'end', ->
    d3.select(this).remove()
    return
  return

# bus_stop#index
setCurrentPosition = (pos) ->
  if pos.coords
    crd = pos.coords
    longitude = crd.longitude
    latitude = crd.latitude
    current.map.setView [latitude, longitude], current.map.getZoom()
  else
    exports.cantGetPosition
  return

setLatLng = () ->
  center = current.map.getCenter()
  $('#latitude').val(center.lat)
  $('#longitude').val(center.lng)
  $('#zoom').val(current.map.getZoom())
  return

searchBusStops = () ->
  center = current.map.getCenter()
  data = {latitude: center.lat, longitude: center.lng}
  $.ajax({
    url: "/api/bus_stops/list",
    data: data,
    dataType: 'json',
    method: 'get'
  }).done(setResult).fail(clearData)

clearData = () ->
  current.drawLayer.clearLayers()
  $('#stop_list').empty()
  return

setResult = (data) ->
  clearData()
  trs = []
  for val in data
    marker = addMarker(val.latitude, val.longitude, val.name, val.status)
    trs.push createTableLine(val, marker)
  $('#stop_list').append(trs)
  return

exports.selectIcon = (fire_status) ->
  icons = {fire_found: fireIcon_found, fire_got_under: fireIcon_gone}
  if (!fire_status? || fire_status == "")
    return icons['fire_found']
  return icon = icons[fire_status]

addMarker = (latitude, longitude, name, status) ->
  return L.marker([latitude, longitude], {icon: selectIcon(status)}).bindPopup(name).addTo(current.drawLayer)

createTableLine = (val, marker) ->
  tr = $('<tr>').attr(id: "stop_" + val.id)
  tr.append $('<td>').text(val.name).addClass("stop_name")
  tr.append createActionButtons(val.id).addClass("action")
  tr.on 'click', (e)->
    current.doSearch = false
    current.map.panTo(marker.getLatLng())
    highlightTableLine(tr)
    marker.openPopup()
    return
  marker.on 'click', ()->
    current.doSearch = false
    highlightTableLine(tr)
    exports.scrollToDom(tr, 'bus_stop_list_list')
    current.map.fire 'openpopup'
    return
  return tr

createActionButtons = (id) ->
  path = "bus_stops/"
  if location.pathname.indexOf("bus_stops/") isnt -1
    path = ""
  $show = $('<a>').addClass("btn btn-default").attr("href", path + id).text("Detail")
  return $('<td>').append($show)

noResultTableLine = () ->
  tr = $('<tr>')
  tr.append $('<td>').attr('colspan', 2).text("No reports around here").css("textAlign", "center")
  return tr

highlightTableLine = ($dom) ->
  exports.highlightTableLine($dom, current.highlightedDom)
  current.highlightedDom = $dom
  $('#selected_id').val($dom.attr('id'))
  return
