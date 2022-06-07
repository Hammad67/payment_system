require 'faker'
FactoryBot.define do
  factory :plan, class: Plan do
    name { 'New Product mm' }
    monthly_fee { '2200' }
  end
end
