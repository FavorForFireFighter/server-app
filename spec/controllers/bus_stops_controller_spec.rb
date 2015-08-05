require 'rails_helper'

RSpec.describe BusStopsController, type: :controller do
  before do
    @stop = FactoryGirl.create(:bus_stop)
  end

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
      get :show, id:@stop.id
      expect(response).to render_template :show
      expect(assigns[:bus_stop]).to eq @stop
      expect(assigns[:information]).to be_truthy
    end
  end

end
