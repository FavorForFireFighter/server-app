json.array! @bus_stops do |bus_stop|
  json.name bus_stop.name
  json.prefecture bus_stop.prefecture.try(:name)
  json.latitude bus_stop.location.try(:y)
  json.longitude bus_stop.location.try(:x)
end