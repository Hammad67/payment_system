class Plan < ApplicationRecord
    validates :name, presence: true 
    validates :monthly_fee, presence: true
    belongs_to :admin 
    has_many :features
end
