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

  describe "soft_deletable" do
    it "soft destroy" do
      @stop.save
      @stop.soft_destroy
      expect(@stop.soft_destroyed?).to be_truthy
      expect(@stop.reload.soft_destroyed_at).to be_truthy
    end

    it "manually soft destroy" do
      @stop.save
      @stop.update(soft_destroyed_at: Time.zone.now)
      expect(@stop.soft_destroyed?).to be_truthy
    end
  end
end
