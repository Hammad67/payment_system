class Feature < ApplicationRecord
  belongs_to :plan
  validates :name, :code, :unit_price, :max_unit_limit, presence: true
  validates :unit_price, numericality: true
  validates :max_unit_limit, numericality: { greater_than: :unit_price }
  validates :name, :code, uniqueness: true, length: { minimum: 10, maximum: 20 }
  has_many :featureusages, dependent: :destroy
end
