require 'faker'
FactoryBot.define do
  factory :subscription, class: Subscription do
    name { 'jhaf7687sgfjajh' }
    monthly_fee { '2200' }
  end
end
