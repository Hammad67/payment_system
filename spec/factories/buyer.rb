require 'faker'
FactoryBot.define do
  factory :buyer, class: User do
    email { Faker::Internet.email }
    name { Faker::Internet.name }
    password { '123456789' }
    type { 'Buyer' }
  end
end
