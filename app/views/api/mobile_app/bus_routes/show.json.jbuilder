if @error.present?
  json.error @error
else
  json.id @bus_route_information.id
  json.name @bus_route_information.bus_line_name
  json.company @bus_route_information.bus_operation_company.id
  json.company_name @bus_route_information.bus_operation_company.name

  json.stops @bus_route_information.bus_stops.each do |bus_stop|
    json.id bus_stop.id
    json.name bus_stop.name
    json.location do
      json.lat bus_stop.location.try(:y)
      json.lng bus_stop.location.try(:x)
    end
  end
end
