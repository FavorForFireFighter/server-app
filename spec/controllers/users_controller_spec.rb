require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
  end
  let(:login) { sign_in :user, @user }

  describe "GET #show" do
    before { login }
    it "returns http success" do
      get :show, id: @user.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @user.id
      expect(response).to render_template :show
      expect(assigns[:user]).to eq @user
    end
  end

  describe "GET #photos" do
    before { login }
    it "returns http success" do
      get :photos, id: @user.id
      expect(response).to have_http_status(:success)
    end
    it "render photos template" do
      get :photos, id: @user.id
      expect(response).to render_template :photos
      expect(assigns[:bus_stop_photos]).to be_truthy
    end
  end

end
