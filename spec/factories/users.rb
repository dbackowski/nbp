FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo#{n}@bar.com" }
    password 'test.123'
    password_confirmation 'test.123'
  end
end
