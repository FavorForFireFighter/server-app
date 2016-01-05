if @error.present?
  json.error @error
else
  json.status true
end
