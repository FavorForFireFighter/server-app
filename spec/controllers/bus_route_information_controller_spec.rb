require 'rails_helper'

RSpec.describe BusRouteInformationController, type: :controller do
  before do
    @user = FactoryGirl.create(:user)
    @route_information = FactoryGirl.create(:bus_route_information)
  end
  let(:login) { session[:id] = @user.id }

  describe "GET #show" do
    before { login }
    it "return http success" do
      get :show, id: @route_information.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :show, id: @route_information.id
      expect(response).to render_template :show
      expect(assigns[:route_information]).to eq @route_information
    end
  end

  describe "GET #edit" do
    before { login }
    it "returns http success" do
      get :edit, id: @route_information.id
      expect(response).to have_http_status(:success)
    end
    it "render show template" do
      get :edit, id: @route_information.id
      expect(response).to render_template :edit
      expect(assigns[:route_information]).to eq @route_information
    end
  end

  describe "PATCH #update" do
    before do
      @valid_name = "Valid Stop Name"
      login
    end
    it "redirect to #show" do
      patch :update, id: @route_information.id, bus_route_information: {bus_line_name: @valid_name}
      expect(response).to redirect_to bus_route_information_path(@route_information.id)
      expect(flash[:notice]).to be_present
    end
    it "change bus_line_name" do
      patch :update, id: @route_information.id, bus_route_information: {bus_line_name: @valid_name}
      expect(@route_information.reload.bus_line_name).to eq @valid_name
    end

    context "invalid name" do
      before do
        @invalid_name = "duplicate name"
        FactoryGirl.create(:bus_route_information, bus_line_name: @invalid_name, bus_operation_company_id: @route_information.bus_operation_company_id)
      end
      it "has error" do
        patch :update, id: @route_information.id, bus_route_information: {bus_line_name: @invalid_name}
        expect(response).to render_template :edit
        expect(assigns[:route_information].errors).to be_present
      end
    end
  end

end
