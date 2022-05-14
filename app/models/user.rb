class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  enum type: {
    Admin: 0,
    Buyer: 1
  }
  after_create :send_email_invite,:stripe_customer
  def send_email_invite
    InviteMailer.with(usermail: self, password: password).welcome_mail.deliver_now if self.type = 'Buyer'
  end
  def stripe_customer
    stripe_cust=Stripe::Customer.create({
      email: "#{self.email}",
    })
    self.update(stripe_cust_id: stripe_cust.id)
  end

end
