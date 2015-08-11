require 'rails_helper'

RSpec.describe Admin::TopController, type: :controller do

  describe "GET #index" do
    context "when user is admin" do
      before do
        user = FactoryGirl.create(:admin)
        session[:id] = user.id
      end
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template :index
      end
    end
    context "when user is not admin" do
      before do
        user = FactoryGirl.create(:user)
        session[:id] = user.id
      end
      it "redirect to root page" do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end
    end
  end

end
