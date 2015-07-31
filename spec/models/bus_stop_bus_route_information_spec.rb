require 'rails_helper'

RSpec.describe BusStopBusRouteInformation, type: :model do
  before do
    @stop_route = FactoryGirl.build(:bus_stop_bus_route_information)
  end

  subject { @stop_route }

  it { should respond_to(:bus_stop_id) }
  it { should respond_to(:bus_route_information_id) }
  it { should be_valid }
end
