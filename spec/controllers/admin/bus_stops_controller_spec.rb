require 'rails_helper'

RSpec.describe Admin::BusStopsController, type: :controller do
  before do
    @admin = FactoryGirl.create(:admin)
    @stop = FactoryGirl.create(:bus_stop)
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
    end
  end

  describe "GET #show" do
    before { login }
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

  describe "DELETE #destroy" do
    before { login }
    it "redirect to " do
      delete :destroy, id: @stop.id
      expect(response).to redirect_to admin_bus_stop_path(@stop.id)
    end
    it "soft destroy" do
      delete :destroy, id: @stop.id
      expect(@stop.reload.soft_destroyed?).to be_truthy
    end
  end

  describe "GET #photos_destroy" do
    before do
      login
      @photo = FactoryGirl.create(:bus_stop_photo_with_photo, bus_stop_id: @stop.id, user_id: @admin.id)
    end
    context "valid params" do
      it "redirect to show" do
        delete :photos_destroy, id: @stop.id, photo_id: @photo.id
        expect(response).to redirect_to admin_bus_stop_path(@stop.id)
        expect(flash[:notice]).to be_present
      end
      it "delete photo" do
        delete :photos_destroy, id: @stop.id, photo_id: @photo.id
        photos = @stop.reload.bus_stop_photos
        expect(photos).to be_empty
      end
      it "other user's photo can delete" do
        user = FactoryGirl.create(:user)
        photo = FactoryGirl.create(:bus_stop_photo_with_photo, bus_stop_id: @stop.id, user_id: user.id)
        delete :photos_destroy, id: @stop.id, photo_id: photo.id
        expect(response).to redirect_to admin_bus_stop_path(@stop.id)
        expect(flash[:notice]).to be_present
      end
    end
  end

end
