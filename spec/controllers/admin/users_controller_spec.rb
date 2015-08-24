require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:admin)
  end
  let(:login) { sign_in :user, @admin }

  describe "GET #index" do
    before { login }
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "render index template" do
      get :index
      expect(response).to render_template :index
      expect(assigns[:users]).to match_array [@user, @admin]
    end
  end

  describe "GET #show" do
    before { login }
    it "returns http success" do
      get :show, id: @admin.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @admin.id
      expect(response).to render_template :show
      expect(assigns[:user]).to eq @admin
    end
  end

  describe "GET #photos_index" do
    before { login }
    it "returns http success" do
      get :photos_index, id: @admin.id
      expect(response).to have_http_status(:success)
    end
    it "render photos template" do
      get :photos_index, id: @admin.id
      expect(response).to render_template :photos_index
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

end
