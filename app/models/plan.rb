class Plan < ApplicationRecord
    validates :name, presence: true 
    validates :monthly_fee, presence: true
    belongs_to :admin 
    has_many :features
    after_create:stripe_plan
    def stripe_plan
      plan=Stripe::Plan.create({
            amount: "#{self.monthly_fee}",
            currency: 'usd',
            interval: 'month',
            product: {name:"#{self.name}"},
          })
          binding.pry
          self.update(stripe_plan_id:plan.id)
    end

end
