class Buyer < User
  has_many :subscriptions
  has_many :plans, through: :subscriptions
  has_many :featureusages
  has_many :transactions
  validates :name, presence: true
  after_create :send_email_invite, :stripe_customer
  after_update :send_email_invite, :update_stripe_customer
  has_one_attached :avatar
  validate :avatar_format

  def avatar_format
    return unless avatar.attached?

    if avatar.blob.content_type.start_with? 'image/'

    else
      errors.add(:avatar, 'needs to be an image')
    end
  end

  def send_email_invite
    InviteMailer.with(usermail: self, password: password).welcome_mail.deliver_now if self.type = 'Buyer'
  end

  def stripe_customer
    stripe_cust = Stripe::Customer.create({
                                            email: email.to_s
                                          })
    update(stripe_cust_id: stripe_cust.id)
  end

  def update_stripe_customer
    stripe_cust = Stripe::Customer.update(
      stripe_cust_id.to_s,
      email: email.to_s
    )
  end

end
