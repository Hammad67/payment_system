class Buyer < User
 has_many :subscriptions
 has_many :plans, through: :subscriptions
end
