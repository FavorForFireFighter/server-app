FactoryGirl.define do
  factory :bus_stop do
    name "MyString"
    location ""
    last_modify_user_id 1
    association :prefecture, factory: :prefecture, strategy: :build
  end

end
