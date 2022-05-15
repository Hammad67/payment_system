class Subscription < ApplicationRecord
    belongs_to :buyer
    belongs_to :plan
end
