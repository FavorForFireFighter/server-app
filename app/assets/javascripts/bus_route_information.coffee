# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

exports = this
$ ->
  if $('#bus_route_information_list_map').is(':visible')
    map = create_leaflet_map 'bus_route_information_list_map'

    exports.drawLayer = L.layerGroup().addTo(map)
    exports.map = map
    data = getData()
    createMarkers(data)
    exports.map.setView [data[0].latitude, data[0].longitude], 13

getData = () ->
  return $.map $('.bus_stop_location'), (dom, index) ->
    $dom = $(dom)
    longitude = $dom.data('longitude')
    latitude = $dom.data('latitude')
    name = $dom.data('name')
    id = $dom.data('id')
    return {name: name, longitude: longitude, latitude: latitude, id: id}

createMarkers = (data) ->
  $.each data, (index, info)->
    marker = L.marker([info.latitude, info.longitude]).bindPopup(info.name).addTo(exports.drawLayer)
    tr = $('#stop_' + info.id).on 'click', () ->
      marker.openPopup()
      exports.highlightTableLine($(this))
      return
    marker.on 'click', () ->
      exports.highlightTableLine(tr)
      return
  return