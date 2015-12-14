if @bus_stop.blank?
  json.error 'Not Found bus_stop'
else
  json.id @bus_stop.id
  json.name @bus_stop.name
  json.prefecture @bus_stop.prefecture.try(:id)
  json.prefecture_name @bus_stop.prefecture.try(:name)
  json.location do
    json.lat @bus_stop.location.try(:y)
    json.lng @bus_stop.location.try(:x)
  end

  json.bus_route_information @bus_stop.bus_route_informations.each do |bus_route_information|
    json.id bus_route_information.id
    json.name bus_route_information.bus_line_name
    json.company bus_route_information.bus_operation_company.id
    json.company_name bus_route_information.bus_operation_company.name
  end

  json.bus_stop_photos @bus_stop.bus_stop_photos.each do |photo|
    json.id photo.id
    json.title photo.title
    json.url URI.join(request.url, photo.photo.url).to_s
    json.thumb URI.join(request.url, photo.photo.url(:thumb)).to_s
    json.bus_stop_id photo.bus_stop_id
    json.user photo.user.id
    json.user_name photo.user.username
  end

end
