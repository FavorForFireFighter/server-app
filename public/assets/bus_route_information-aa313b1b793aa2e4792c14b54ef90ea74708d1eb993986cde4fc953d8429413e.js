(function() {
  var createMarkers, current, exports, getData, highlightTableLine;

  exports = this;

  current = {};

  $(function() {
    var data, map, tr;
    if ($('#bus_route_information_list_map').is(':visible')) {
      map = create_leaflet_map('bus_route_information_list_map');
      current.drawLayer = L.featureGroup().addTo(map);
      current.map = map;
      data = getData();
      if (exports.isBlank(data)) {
        exports.initMap(current.map);
        tr = $('<tr>');
        tr.append($('<td>').attr('colspan', 2).text("該当データがありませんでした").css("textAlign", "center"));
        $('#stop_list').append(tr);
        return;
      }
      createMarkers(data);
      current.map.fitBounds(current.drawLayer.getBounds());
      current.map.on('moveend', function() {
        var ajax, center;
        if (current.doSearch) {
          center = current.map.getCenter();
          ajax = $.ajax({
            url: location.pathname,
            data: {
              latitude: center.lat,
              longitude: center.lng
            },
            dataType: 'json',
            method: 'get'
          });
          ajax.done(function(data) {
            var ids, trs;
            ids = data.ids;
            trs = $.map(ids, function(id) {
              return $('#stop_' + id);
            });
            $('tr[id^=stop_]').detach();
            $('#stop_list').append(trs);
            $('#bus_stop_list_list').scrollTop(0);
          });
        }
        current.doSearch = true;
      });
      current.doSearch = true;
      return current.map.fire('moveend');
    }
  });

  getData = function() {
    return $.map($('.bus_stop_location'), function(dom, index) {
      var $dom, id, latitude, longitude, name;
      $dom = $(dom);
      longitude = $dom.data('longitude');
      latitude = $dom.data('latitude');
      name = $dom.data('name');
      id = $dom.data('id');
      return {
        name: name,
        longitude: longitude,
        latitude: latitude,
        id: id
      };
    });
  };

  createMarkers = function(data) {
    $.each(data, function(index, info) {
      var marker, tr;
      marker = L.marker([info.latitude, info.longitude]).bindPopup(info.name).addTo(current.drawLayer);
      tr = $('#stop_' + info.id).on('click', function() {
        current.doSearch = false;
        current.map.panTo(marker.getLatLng());
        marker.openPopup();
        highlightTableLine($(this));
      });
      return marker.on('click', function() {
        current.doSearch = false;
        highlightTableLine(tr);
        exports.scrollToDom(tr, 'bus_stop_list_list');
      });
    });
  };

  highlightTableLine = function($dom) {
    exports.highlightTableLine($dom, current.highlightedDom);
    current.highlightedDom = $dom;
  };

}).call(this);
