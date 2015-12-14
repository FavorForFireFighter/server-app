json.id @user.id
json.username @user.username
json.email @user.email
json.photos @user.bus_stop_photos do |photo|
  json.id photo.id
  json.title photo.title
  json.url URI.join(request.url, photo.photo.url).to_s
  json.thumb URI.join(request.url, photo.photo.url(:thumb)).to_s
  json.bus_stop_id photo.bus_stop_id
end
