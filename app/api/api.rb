module API
  class Base < Grape::API
    prefix 'api'
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    mount BusStopsApi
  end
end