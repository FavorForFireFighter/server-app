require 'rails_helper'

RSpec.describe BusRouteInformation, type: :model do
  before do
    @route = FactoryGirl.build(:bus_route_information)
  end

  subject { @route }

  it { should respond_to(:bus_type_id) }
  it { should respond_to(:bus_operation_company_id) }
  it { should respond_to(:bus_line_name) }
  it { should be_valid }
end
