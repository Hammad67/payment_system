require 'faker'
FactoryBot.define do
  factory :feature, class: Feature do
    name { 'jhaf7687sgfjajh' }
    code { 'hgesssj9856shvajhb' }
    unit_price { '22' }
    max_unit_limit { '220' }
  end
end
