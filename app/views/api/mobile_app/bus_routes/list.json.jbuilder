json.array! @lines do |line|
  json.id line.id
  json.name line.bus_line_name
end