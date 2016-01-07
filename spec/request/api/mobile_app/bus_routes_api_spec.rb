require 'rails_helper'

RSpec.describe MobileApp::BusRoutesApi, :type => :request do

  before do
    @user = FactoryGirl.create(:user)
    @route = FactoryGirl.create(:bus_route_information)
  end
  let(:login) { headers.merge! @user.create_new_auth_token @user.email }

  describe "GET /api/app/bus_routes/show" do
    context "valid id" do
      let(:params) { {id: @route.id} }
      let(:body) { response.body }
      it "return detail of route" do
        is_expected.to eq 200
        expect(body).to have_json_path("id")
        expect(body).to have_json_path("name")
        expect(body).to have_json_path("company")
        expect(body).to have_json_path("company_name")
        expect(body).to have_json_path("stops")
        expect(body).to have_json_type(Array).at_path("stops")
      end
    end

    context "invalid id" do
      let(:params) { {id: -1} }
      let(:body) { response.body }
      it "return 404" do
        is_expected.to eq 404
      end
    end
  end

  describe "PATCH /api/app/bus_routes/edit" do
    let(:params) { {id: @route.id} }
    let(:body) { response.body }

    context "valid params" do
      before do
        login
        params[:name] = "new_name"
      end
      it "success to update" do
        is_expected.to eq 200
        expect(@route.reload.bus_line_name).to eq "new_name"
      end
    end

    context "invalid params" do
      before do
        login
        params[:name] = " "
      end
      it "failed to update" do
        is_expected.to eq 400
        expect(body).to have_json_path("error")
      end
    end

    context "not login" do
      it "return not authorized" do
        params[:name] = "new_name"
        is_expected.to eq 401
      end
    end
  end

  describe "GET /api/app/bus_routes/companies" do
    let(:body) { response.body }

    context "valid params" do
      before do
        login
        params[:name] = @route.bus_operation_company.name
      end
      it "list companies" do
        is_expected.to eq 200
        expect(body).to have_json_path("0/id")
        expect(body).to have_json_path("0/name")
      end
    end

    context "invalid params" do
      before do
        login
        params[:name] = ""
      end
      it "return empty array" do
        is_expected.to eq 404
        expect(body).to be_json_eql(%([]))
      end
    end

    context "not login" do
      it "return not authorized" do
        params[:name] = @route.bus_operation_company.name
        is_expected.to eq 401
      end
    end
  end

  describe "GET /api/app/bus_routes/routes" do
    let(:body) { response.body }

    context "valid params" do
      before do
        login
        params[:company_id] = @route.bus_operation_company_id
      end
      it "list routes" do
        is_expected.to eq 200
        expect(body).to have_json_path("0/id")
        expect(body).to have_json_path("0/name")
      end
    end

    context "invalid params" do
      before do
        login
        params[:company_id] = -1
      end
      it "return empty array" do
        is_expected.to eq 404
        expect(body).to be_json_eql(%([]))
      end
    end

    context "not login" do
      it "return not authorized" do
        params[:company_id] = @route.bus_operation_company_id
        is_expected.to eq 401
      end
    end
  end

  describe "POST /api/app/bus_routes/create" do
    let(:params) { {company_id: @route.bus_operation_company_id} }
    let(:body) { response.body }

    context "valid params" do
      before { login }
      describe "with existing company" do
        let(:params) { {company_id: @route.bus_operation_company_id,
                        company_name: @route.bus_operation_company.name,
                        route_id: -1, route_name: "new_route", bus_type: 1} }
        it "success to create" do
          is_expected.to eq 201
          expect(BusRouteInformation.find_by bus_line_name: "new_route").to be_truthy
        end
      end
      describe "with new company" do
        let(:params) { {company_id: -1, company_name: "new_company",
                        route_id: -1, route_name: "new_route", bus_type: 1} }
        it "success to create" do
          is_expected.to eq 201
          expect(BusOperationCompany.find_by name: "new_company").to be_truthy
          expect(BusRouteInformation.find_by bus_line_name: "new_route").to be_truthy
        end
      end
    end

    context "invalid params" do
      before { login }
      let(:params) { {company_id: -1, company_name: "",
                      route_id: -1, route_name: "", bus_type: -1} }
      it "return empty array" do
        is_expected.to eq 400
        expect(body).to have_json_path("error")
      end
    end

    context "not login" do
      let(:params) { {company_id: -1, company_name: "new_company",
                      route_id: -1, route_name: "new_route", bus_type: 1} }
      it "return not authorized" do
        is_expected.to eq 401
      end
    end
  end
end

