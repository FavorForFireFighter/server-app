require 'rails_helper'

RSpec.describe MobileApp::BusStopPhotosApi, :type => :request do

  before do
    @photo = FactoryGirl.create(:bus_stop_photo_with_photo, user: @user)
  end

  describe "PATCH /api/app/bus_stop_photos/report" do
    context "valid id" do
      let(:params) { {id: @photo.id} }
      let(:body) { response.body }
      it "success to report" do
        is_expected.to eq 200
        expect(@photo.reload.reporting).to eq 1
      end
    end

    context "invalid id" do
      let(:params) { {id:-1} }
      let(:body) { response.body }
      it "return 404" do
        is_expected.to eq 404
      end
    end
  end
end
