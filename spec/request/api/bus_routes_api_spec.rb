require 'rails_helper'

RSpec.describe BusRoutesApi, :type => :request do

  before do
    @company = FactoryGirl.create(:bus_operation_company, name: "BusCompany")
    @line = FactoryGirl.create(:bus_route_information, bus_operation_company_id: @company.id)
    FactoryGirl.create(:bus_route_information)
  end

  let(:body) { response.body }

  describe "GET /api/bus_routes/companies" do
    context "with invalid name" do
      let(:params) { {name: "invalid"} }
      it "not found" do
        is_expected.to eq 404
      end
    end

    context "with part of valid name" do
      let(:params) { {name: @company.name[1..3]} }
      it "return @company" do
        is_expected.to eq 200
        expect(body).to be_json_eql(%([{"name":"#{@company.name}","id":"#{@company.id}"}]))
      end
    end
  end

  describe "GET /api/bus_routes/lines" do
    context "with invalid company_id" do
      let(:params) { {company_id: -1} }
      it "not found" do
        is_expected.to eq 404
      end
    end

    context "with valid company_id" do
      let(:params) { {company_id: @company.id} }
      it "return @line" do
        is_expected.to eq 200
        expect(body).to be_json_eql(%([{"name":"#{@line.bus_line_name}","id":"#{@line.id}"}]))
      end
    end
  end

  describe "POST /api/bus_routes/register" do
    context "register both of company and line" do
      let(:params) { {company_id: -1, company_name: "Test", line_id: -1, line_name: "Test"} }
      it "return success" do
        is_expected.to eq 201
        company = BusOperationCompany.find_by(name: "Test")
        expect(company).to be_present
        line = BusRouteInformation.find_by(bus_line_name: "Test")
        expect(line.bus_operation_company_id).to eq company.id
        expect(body).to be_json_eql(%({"success":true,"company_id":#{company.id},"line_id":#{line.id}}))
      end
    end

    context "register only line" do
      let(:params) { {company_id: @company.id, company_name: @company.name, line_id: -1, line_name: "Test"} }
      it "return success" do
        is_expected.to eq 201
        company = BusOperationCompany.where(name: @company.name)
        expect(company.count).to eq 1
        line = BusRouteInformation.find_by(bus_line_name: "Test")
        expect(line.bus_operation_company_id).to eq @company.id
        expect(body).to be_json_eql(%({"success":true,"company_id":#{@company.id},"line_id":#{line.id}}))
      end
    end

    context "with invalid params" do
      let(:params) { {company_id: -1, company_name: "", line_id: -1, line_name: "Test"} }
      it "return fail" do
        is_expected.to eq 400
        expect(body).to be_json_eql(%({"success":false,"company_id":null,"line_id":null}))
        line = BusRouteInformation.find_by(bus_line_name: "Test")
        expect(line).to be_falsey
      end
    end
  end

  describe "GET /api/bus_routes/line" do
    context "with invalid id" do
      let(:params) { {line_id: -1} }
      it "not found" do
        is_expected.to eq 404
      end
    end

    context "with valid id" do
      let(:params) { {line_id: @line.id} }
      it "return @company" do
        is_expected.to eq 200
        expect(body).to be_json_eql(%({"name":"#{@line.bus_line_name}","id":"#{@line.id}"}))
      end
    end
  end
end
