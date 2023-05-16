FactoryBot.define do
  factory :dummy do
    name { "MyString" }
    age { 1 }
    dob { "2023-05-16 15:51:47" }
    # n will start from 1 and inc by 1 each time we call factory
    sequence(:email) { |n| "my-#{n}@email.com"}
  end
end
