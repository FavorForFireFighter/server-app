exports = this
$ ->
  $('.selectpicker').selectpicker('mobile')
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