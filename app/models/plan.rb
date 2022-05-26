# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { minimum: 10, maximum: 20 }
  validates :monthly_fee, presence: true
  has_and_belongs_to_many :features
  has_many :subscriptions, dependent: :destroy
  has_many :buyers, through: :subscriptions
  has_many :transactions, dependent: :destroy

  after_create :stripe_plan
  def stripe_plan
    plan = StripeService.new.create_stripe_plan(monthly_fee, name)
    update(stripe_plan_id: plan.id)
  end
end
