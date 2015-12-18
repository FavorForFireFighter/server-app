if @error.present?
  json.error @error
else
  json.company_id @company.id
  json.company_name @company.name
  json.route_id @bus_route.id
  json.route_name @bus_route.bus_line_name
end
