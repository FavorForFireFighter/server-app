json.array! @bus_stops do |bus_stop|
  json.id bus_stop.id
  json.name bus_stop.name
  json.location do
    json.lat bus_stop.location.try(:y)
    json.lng bus_stop.location.try(:x)
  end
end