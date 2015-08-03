require 'rails_helper'

RSpec.describe BusStop, type: :model do
  before do
    @stop = FactoryGirl.build(:bus_stop)
  end

  subject { @stop }

  it { should respond_to(:name) }
  it { should respond_to(:prefecture_id) }
  it { should respond_to(:location) }
  it { should respond_to(:location_updated_at) }
  it { should respond_to(:last_modify_user_id) }
  it { should be_valid }
end
