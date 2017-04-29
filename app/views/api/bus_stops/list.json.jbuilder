json.array! @bus_stops do |bus_stop|
  json.id bus_stop.id
  json.name bus_stop.name
  json.latitude bus_stop.location.try(:y)
  json.longitude bus_stop.location.try(:x)
end
