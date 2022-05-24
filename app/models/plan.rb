class Plan < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :monthly_fee, presence: true
  belongs_to :admin
  has_many :features, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :buyers, through: :subscriptions
  has_many :transactions, dependent: :destroy
  after_create :stripe_plan
  def stripe_plan
    plan=StripeCustomer.new.createstripeplan(monthly_fee,name)
    self.update(stripe_plan_id: plan.id)
  end
end
