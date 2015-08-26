# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

exports = this
current = {}
$ ->
  if $('#bus_route_information_list_map').is(':visible')
    map = create_leaflet_map 'bus_route_information_list_map'

    current.drawLayer = L.featureGroup().addTo(map)
    current.map = map
    data = getData()
    if exports.isBlank(data)
      exports.initMap current.map
      tr = $('<tr>')
      tr.append $('<td>').attr('colspan', 2).text("該当データがありませんでした").css("textAlign", "center")
      $('#stop_list').append tr
      return
    createMarkers(data)
    current.map.fitBounds(current.drawLayer.getBounds())

    current.map.on 'moveend', () ->
      if current.doSearch
        center = current.map.getCenter()
        ajax = $.ajax({
          url: location.pathname,
          data: {latitude: center.lat, longitude: center.lng}
          dataType: 'json',
          method: 'get'
        })
        ajax.done (data) ->
          ids = data.ids
          trs = $.map ids, (id)->
            return $('#stop_' + id)
          $('tr[id^=stop_]').detach()
          $('#stop_list').append(trs)
          $('#bus_stop_list_list').scrollTop(0)
          return
      current.doSearch = true
      return

    current.doSearch = true
    current.map.fire('moveend')

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
    marker = L.marker([info.latitude, info.longitude]).bindPopup(info.name).addTo(current.drawLayer)
    tr = $('#stop_' + info.id).on 'click', () ->
      current.doSearch = false
      current.map.panTo marker.getLatLng()
      marker.openPopup()
      highlightTableLine($(this))
      return
    marker.on 'click', () ->
      current.doSearch = false
      highlightTableLine(tr)
      exports.scrollToDom(tr, 'bus_stop_list_list')
      return
  return

highlightTableLine = ($dom) ->
  exports.highlightTableLine($dom, current.highlightedDom)
  current.highlightedDom = $dom
  return