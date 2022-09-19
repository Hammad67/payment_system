require 'faker'
FactoryBot.define do
  factory :admin, class: User do
    email { Faker::Internet.email }
    name { Faker::Internet.name }
    password { '123456789' }
    type { 'Admin' }
  end
end
