require 'rails_helper'

RSpec.describe BusStopsApi, :type => :request do

  before do
    @stop1 = FactoryGirl.create(:bus_stop)
    @stop2 = FactoryGirl.create(:bus_stop, location: "POINT(139.766865 35.681109)")
  end

  describe "GET /api/bus_stops/list" do

    context "with location that out of search range" do
      let(:params) { {latitude: 33.681109, longitude: 139.766865} }
      let(:body) { response.body }
      it "not found" do
        is_expected.to eq 404
      end
    end

    context "with location in range of searching" do
      let(:params) { {latitude: 35.681109, longitude: 139.766865} }
      let(:body) { response.body }
      it "return @stop2" do
        is_expected.to eq 200
        expect(body).to be_json_eql(%([{"name":"#{@stop2.name}","prefecture":"#{@stop2.prefecture.name}","latitude":#{@stop2.location.y},"longitude":#{@stop2.location.x}}]))
      end
    end

  end
end
