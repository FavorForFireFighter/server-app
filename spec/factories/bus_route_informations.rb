FactoryGirl.define do
  factory :bus_route_information do
    bus_type_id 1
    bus_line_name "MyString"
    association :bus_operation_company, factory: :bus_operation_company, strategy: :build
  end

end
