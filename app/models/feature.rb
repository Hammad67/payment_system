class Feature < ApplicationRecord
    belongs_to :plan
   validates :name,:code,:unit_price,:max_unit_limit, presence:true
   validates :unit_price,:max_unit_limit ,numericality: {only_integer: true }
end
