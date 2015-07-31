require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  before do
    @prefecture = FactoryGirl.build(:prefecture)
  end

  subject { @prefecture }

  it { should respond_to(:name) }
  it { should respond_to(:location) }
  it { should be_valid }
end
