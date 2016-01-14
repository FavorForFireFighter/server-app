require 'rails_helper'

RSpec.describe MobileApp::BusStopsApi, :type => :request do

  before do
    @stop1 = FactoryGirl.create(:bus_stop)
    route = FactoryGirl.create(:bus_route_information)
    @stop1.bus_route_informations = [route]
    @stop1.save
    @stop2 = FactoryGirl.create(:bus_stop, location: "POINT(139.766865 35.681109)")
    @user = FactoryGirl.create(:user)
  end
  let(:login) { headers.merge! @user.create_new_auth_token @user.email }

  describe "GET /api/app/bus_stops/list" do

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
        expect(body).to be_json_eql(%([{"name":"#{@stop2.name}","location":{"lat":#{@stop2.location.y},"lng":#{@stop2.location.x}},"is_updated": true}]))
      end
    end

    context "with range" do
      let(:params) { {latitude: 35.681109, longitude: 139.766865, range: 500} }
      let(:body) { response.body }
      it "return @stop2" do
        is_expected.to eq 200
        expect(body).to be_json_eql(%([{"name":"#{@stop2.name}","location":{"lat":#{@stop2.location.y},"lng":#{@stop2.location.x}},"is_updated": true}]))
      end

      describe "invalid range" do
        let(:params) { {latitude: 35.681109, longitude: 139.766865, range: 1500} }
        it "return @stop2" do
          is_expected.to eq 400
        end
      end
    end
  end

  describe "GET /api/app/bus_stops/show" do

    context "with valid id" do
      let(:params) { {id: @stop2.id} }
      let(:body) { response.body }
      it "return @stop2 detail" do
        is_expected.to eq 200
        expect(body).to have_json_path("id")
        expect(body).to have_json_path("name")
        expect(body).to have_json_path("prefecture")
        expect(body).to have_json_path("prefecture_name")
        expect(body).to have_json_path("location")
        expect(body).to have_json_path("location/lat")
        expect(body).to have_json_path("location/lng")
        expect(body).to have_json_path("bus_route_information")
        expect(body).to have_json_type(Array).at_path("bus_route_information")
        expect(body).to have_json_path("bus_stop_photos")
        expect(body).to have_json_type(Array).at_path("bus_stop_photos")
      end
    end

    context "with invalid id" do
      let(:params) { {id: -1} }
      let(:body) { response.body }
      it "return error" do
        is_expected.to eq 404
        expect(body).to have_json_path("error")
      end
    end

  end

  describe "PATCH /api/app/bus_stops/edit" do
    before do
      @routes = @stop1.bus_route_informations.map do |route|
        route.id
      end
      login
    end
    context "valid params" do
      let(:params) { {id: @stop1.id, name: "new_name",
                      prefecture: @stop1.prefecture.id,
                      latitude: @stop1.location.y, longitude: @stop1.location.x,
                      location_updated_at: false, routes: @routes,
                      photos: [-1]} }
      let(:body) { response.body }

      it "success to update" do
        is_expected.to eq 200
        expect(@stop1.reload.name).to eq "new_name"
      end

      it "success to upload photo" do
        photo = fixture_file_upload("rails.png", "image/png", true)
        params[:new_photos] = [{title: "test", photo: "data:image/png;base64," + Base64.encode64(photo.read)}]
        is_expected.to eq 200
        expect(@stop1.reload.bus_stop_photos.size).to eq 1
        expect(@stop1.reload.bus_stop_photos.first.title).to eq "test"
      end
    end

    context "invalid params" do
      let(:params) { {id: @stop1.id, name: "new_name",
                      prefecture: @stop1.prefecture.id,
                      latitude: @stop1.location.y, longitude: @stop1.location.x,
                      location_updated_at: false, routes: @routes,
                      photos: [-1]} }
      let(:body) { response.body }

      it "return error of route" do
        params[:routes] = []
        is_expected.to eq 400
        expect(body).to have_json_path("error")
      end
      it "return error of photo" do
        params[:new_photos] = [{title: "", photo: ""}]
        is_expected.to eq 400
        expect(body).to have_json_path("error")
      end
    end
  end

  describe "POST /api/app/bus_stops/create" do
    before do
      @routes = @stop1.bus_route_informations.map do |route|
        route.id
      end
      login
    end
    context "valid params" do
      let(:params) { {name: "new_stop",
                      prefecture: @stop1.prefecture.id,
                      latitude: @stop1.location.y, longitude: @stop1.location.x,
                      location_updated_at: true, routes: @routes} }
      let(:body) { response.body }

      it "success to create" do
        is_expected.to eq 201
        expect(BusStop.find_by name: "new_stop").to be_truthy
      end
    end

    context "invalid params" do
      let(:params) { {id: @stop1.id, name: "new_name",
                      prefecture: @stop1.prefecture.id,
                      latitude: @stop1.location.y, longitude: @stop1.location.x,
                      location_updated_at: false, routes: @routes,
                      photos: [-1]} }
      let(:body) { response.body }

      it "return error of route" do
        params[:routes] = []
        is_expected.to eq 400
        expect(body).to have_json_path("error")
      end
    end
  end
end
