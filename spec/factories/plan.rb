require 'faker'
FactoryBot.define do
  factory :plan, class: Plan do
    name { 'jhaf7687sgfjajh' }
    monthly_fee { '2200' }
  end
end
