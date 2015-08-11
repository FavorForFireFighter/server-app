require 'rails_helper'

RSpec.describe Admin::PhotosController, type: :controller do
  before do
    @admin = FactoryGirl.create(:admin)
  end
  let(:login) { session[:id] = @admin.id }

  describe "GET #index" do
    before { login }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "render photos template" do
      get :index
      expect(response).to render_template :index
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

end
