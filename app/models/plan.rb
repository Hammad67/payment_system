# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, presence: true
  validates :monthly_fee, presence: true
  belongs_to :admin
  has_many :features # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :subscriptions # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :buyers, through: :subscriptions
  has_many :transactions # rubocop:todo Rails/HasManyOrHasOneDependent
  after_create :stripe_plan
  def stripe_plan
    plan = Stripe::Price.create({
                                  unit_amount: (monthly_fee * 100).to_s,
                                  currency: 'usd',
                                  recurring: { interval: 'month' },
                                  product_data: { name: name.to_s }
                                })

    update(stripe_plan_id: plan.id)
  end
end
