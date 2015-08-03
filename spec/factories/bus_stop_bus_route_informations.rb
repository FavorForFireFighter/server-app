FactoryGirl.define do
  factory :bus_stop_bus_route_information do
    association :bus_stop, factory: :bus_stop, strategy: :build
    association :bus_route_information, factory: :bus_route_information, strategy: :build
  end

end
