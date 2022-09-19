# frozen_string_literal: true

# plan model
class Plan < ApplicationRecord
  has_many :features_plans
  has_many :features, through: :features_plans
  validates :name, presence: true
  validates :name, length: { minimum: 10, maximum: 20,
                             message: 'Invalid length minimum 10 maximum 20 characters allowed' }
  validates :monthly_fee, presence: true
  has_many :subscriptions, dependent: :destroy
  has_many :buyers, through: :subscriptions
  has_many :transactions, dependent: :destroy

  after_create :stripe_plan
  def stripe_plan
    plan = StripeService.create_stripe_plan(monthly_fee, name)
    update(stripe_plan_id: plan.id)
  end
end
