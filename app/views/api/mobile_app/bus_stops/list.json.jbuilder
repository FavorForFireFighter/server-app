json.array! @bus_stops do |bus_stop|
  json.id bus_stop.id
  json.name bus_stop.name
  json.location do
    json.lat bus_stop.location.try(:y)
    json.lng bus_stop.location.try(:x)
  end
  json.created_at bus_stop.created_at
  json.updated_at bus_stop.updated_at
  if bus_stop.versions.present? && bus_stop.versions.last.present? &&!bus_stop.versions.last.whodunnit.nil?
    json.is_updated true
  else
    json.is_updated false
  end
end