class Plan < ApplicationRecord
    validates :name, presence: true 
    validates :monthly_fee, presence: true
    belongs_to :admin 
    has_many :features
    has_many :subscriptions
    has_many :buyers, through: :subscriptions
    has_many :transactions
    after_create:stripe_plan
    def stripe_plan
        
       plan=Stripe::Price.create({
            unit_amount: 2000,
            currency: 'usd',
            recurring: {interval: 'month'},
            product_data: {name:"#{self.name}"},
          })
    
          self.update(stripe_plan_id:plan.id)
         
    end

end
