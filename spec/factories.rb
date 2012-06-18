FactoryGirl.define do
  factory :user do
    sequence(:name)     {|n| "GoodMan#{n}"}
		sequence(:email) 	  {|n| "goodman#{n}@great.com"}
    password    "goodmanisin"
  end

  #factory :user do
  #  name      "GoodMan"
		#email 	  "goodman@great.com"
  #  password    "goodmanisin"
  #end

  factory :contact do
    name     "Goodman_Contact"
    user
  end
end