FactoryGirl.define do
  factory :bus_stop do
    name "MyString"
    location "POINT(139.738107 35.632778)"
    last_modify_user_id 1
    prefecture_id {rand(47) + 1}
  end

end
