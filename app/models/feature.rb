# frozen_string_literal: true

# Feature model
class Feature < ApplicationRecord
  has_many :features_plans, dependent: :destroy
  has_many :plans, through: :features_plans
  validates :name, :code, :unit_price, :max_unit_limit, presence: true
  validates :unit_price, numericality: true
  validates :max_unit_limit, numericality: { greater_than: :unit_price }
  validates :name, :code, length: { minimum: 10, maximum: 20 }
  has_many :featureusages, dependent: :destroy
end
