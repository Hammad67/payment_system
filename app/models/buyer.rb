# frozen_string_literal: true

class Buyer < User
  has_many :subscriptions # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :plans, through: :subscriptions
  has_many :featureusages # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :transactions # rubocop:todo Rails/HasManyOrHasOneDependent
  after_create :send_email_invite, :stripe_customer

  def send_email_invite
    # rubocop:todo Lint/AssignmentInCondition

    InviteMailer.with(usermail: self, password: password).welcome_mail.deliver_now if self.type = 'Buyer'
    # rubocop:enable Lint/AssignmentInCondition
  end

  def stripe_customer
    stripe_cust = Stripe::Customer.create({
                                            email: email.to_s
                                          })
    update(stripe_cust_id: stripe_cust.id)
  end
end
