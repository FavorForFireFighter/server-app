require 'rails_helper'

RSpec.describe BusStopsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @stop = FactoryGirl.create(:bus_stop)
  end

  let(:login) { sign_in :user, @user }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "render index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, id: @stop.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @stop.id
      expect(response).to render_template :show
      expect(assigns[:bus_stop]).to eq @stop
      expect(assigns[:information]).to be_truthy
    end
  end

  describe "GET #new" do
    before { login }
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
    it "render new template" do
      get :new
      expect(response).to render_template :new
      expect(assigns[:bus_stop]).to be_a_new(BusStop)
      expect(assigns[:prefectures]).to be_truthy
      expect(assigns[:route_information]).to be_truthy
    end

    context "when passed id" do
      it "duplicate stop" do
        get :new, id: @stop.id
        expect(response).to render_template :new
        expect(assigns[:bus_stop].name).to eq @stop.name
        expect(assigns[:prefectures]).to be_truthy
        expect(assigns[:route_information]).to be_truthy
      end
    end
  end

  describe "POST #create" do
    before do
      login
      @route_information = FactoryGirl.create(:bus_route_information)
    end
    let(:valid_params) { {bus_stop: {name: "test_stop", prefecture_id: 13}, bus_route_information: {id: [@route_information.id]},
                          latitude: 35.632778, longitude: 139.738107, location_update_at: "true"} }

    context "with valid params" do
      it "redirect to show" do
        post :create, valid_params
        bus_stop = BusStop.find_by(name: valid_params[:bus_stop][:name])
        expect(response).to redirect_to bus_stop_url(bus_stop.id)
      end

      it "create new BusStop" do
        post :create, valid_params
        bus_stop = BusStop.find_by(name: valid_params[:bus_stop][:name])
        expect(bus_stop).to be_present
        expect(@route_information.bus_stops).to match_array [bus_stop]
      end
    end

    context "with invalid params" do
      let(:no_route_information) do
        valid_params.delete(:bus_route_information)
        valid_params
      end
      let(:invalid_stop_name) do
        valid_params[:bus_stop][:name] = ""
        valid_params
      end
      let(:invalid_location) do
        valid_params.delete(:latitude)
        valid_params
      end
      it "no route_information" do
        post :create, no_route_information
        expect(response).to render_template :new
        expect(flash[:error]).to be_present
      end
      it "invalid_stop_name" do
        post :create, invalid_stop_name
        expect(response).to render_template :new
        expect(assigns[:bus_stop].errors).to be_present
      end
      it "no location" do
        post :create, invalid_location
        expect(response).to render_template :new
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET #edot" do
    before { login }
    it "returns http success" do
      get :edit, id: @stop.id
      expect(response).to have_http_status(:success)
    end
    it "render new template" do
      get :edit, id: @stop.id
      expect(response).to render_template :edit
      expect(assigns[:bus_stop]).to eq @stop
      expect(assigns[:prefectures]).to be_truthy
      expect(assigns[:route_information]).to match_array @stop.bus_route_informations
    end
  end

  describe "PATCH #update" do
    before do
      login
      @route_information = FactoryGirl.create(:bus_route_information)
    end
    let(:valid_params) { {id: @stop.id, bus_stop: {name: "test_stop", prefecture_id: 13}, bus_route_information: {id: @stop.bus_route_informations.ids.concat([@route_information.id])},
                          latitude: 35.632778, longitude: 139.738107, location_update_at: "true"} }

    context "with valid params" do
      it "redirect to show" do
        patch :update, valid_params
        bus_stop = BusStop.find_by(name: valid_params[:bus_stop][:name])
        expect(response).to redirect_to bus_stop_url(bus_stop.id)
      end

      it "update attributes" do
        patch :update, valid_params
        expect(@stop.reload.name).to eq valid_params[:bus_stop][:name]
        expect(@stop.reload.bus_route_informations.ids).to match_array valid_params[:bus_route_information][:id]
      end
    end

    context "with invalid params" do
      let(:no_route_information) do
        valid_params.delete(:bus_route_information)
        valid_params
      end
      let(:invalid_stop_name) do
        valid_params[:bus_stop][:name] = ""
        valid_params
      end
      let(:invalid_location) do
        valid_params.delete(:latitude)
        valid_params
      end
      it "no route_information" do
        patch :update, no_route_information
        expect(response).to render_template :edit
        expect(flash[:error]).to be_present
      end
      it "invalid_stop_name" do
        patch :update, invalid_stop_name
        expect(response).to render_template :edit
        expect(assigns[:bus_stop].errors).to be_present
      end
      it "no location" do
        patch :update, invalid_location
        expect(response).to render_template :edit
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "GET #photos_new" do
    before do
      login
    end
    it "returns http success" do
      get :photos_new, id: @stop.id
      expect(response).to have_http_status(:success)
    end
    it "render photos_new template" do
      get :photos_new, id: @stop.id
      expect(response).to render_template :photos_new
      expect(assigns[:bus_stop_photo]).to be_a_new(BusStopPhoto)
    end
  end

  describe "POST #photos_create" do
    before do
      login
      photo = fixture_file_upload("rails.png", "image/png", true)
      @valid_params = {title: "Test Photo", photo: photo}
      @invalid_params = {title: "", photo: nil}
    end
    context "valid params" do
      it "redirect to show" do
        post :photos_create, id: @stop.id, bus_stop_photo: @valid_params
        expect(response).to redirect_to @stop
      end
      it "create BusStopPhoto" do
        post :photos_create, id: @stop.id, bus_stop_photo: @valid_params
        photo = @stop.reload.bus_stop_photos
        expect(photo.count).to eq 1
        expect(photo.first.title).to eq @valid_params[:title]
      end
    end
    context "invalid params" do
      it "render photos_new template" do
        post :photos_create, id: @stop.id, bus_stop_photo: @invalid_params
        expect(response).to render_template :photos_new
      end
    end
  end

  describe "DELETE #photos_destroy" do
    before do
      login
      @photo = FactoryGirl.create(:bus_stop_photo_with_photo, bus_stop_id: @stop.id, user_id: @user.id)
    end

    context "valid params" do
      it "redirect to show" do
        delete :photos_destroy, id: @stop.id, photo_id: @photo.id
        expect(response).to redirect_to @stop
        expect(flash[:notice]).to be_present
      end
      it "delete photo" do
        delete :photos_destroy, id: @stop.id, photo_id: @photo.id
        photos = @stop.reload.bus_stop_photos
        expect(photos).to be_empty
      end
    end
    context "invalid params" do
      it "other user's photo" do
        user = FactoryGirl.create(:user)
        sign_in :user, user
        delete :photos_destroy, id: @stop.id, photo_id: @photo.id
        expect(response).to redirect_to @stop
        expect(flash[:alert]).to be_present
      end
    end
  end

end
