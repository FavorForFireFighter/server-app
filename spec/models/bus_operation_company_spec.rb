require 'rails_helper'

RSpec.describe BusOperationCompany, type: :model do
  before do
    @company = FactoryGirl.build(:bus_operation_company)
  end

  subject { @company }

  it { should respond_to(:name) }
  it { should be_valid }

end
