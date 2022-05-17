class Buyer < User
 has_many :subscriptions
 has_many :plans, through: :subscriptions
 has_many :featureusages
 has_many :transactions
end
