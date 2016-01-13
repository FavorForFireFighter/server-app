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
    json.created_at bus_stop.created_at
    json.updated_at bus_stop.updated_at
    if bus_stop.last_modify_user_id.blank?
      json.is_updated false
    else
      json.is_updated true
    end
  end
end
