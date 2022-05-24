class Buyer < User
  has_many :subscriptions,dependent: :destroy
  has_many :plans, through: :subscriptions
  has_many :featureusages,dependent: :destroy
  has_many :transactions,dependent: :destroy
  validates :name, presence: true
  after_create :send_email_invite, :stripe_customer

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
    StripeCustomer.new.new_stripe_customer(self)
  end



end
