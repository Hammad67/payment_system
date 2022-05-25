class Buyer < User
  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  has_many :featureusages, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true, uniqueness: true
  validates :name, length: { minimum: 10, maximum: 20 }
  validate :avatar_format

  after_create :send_email_invite, :stripe_customer


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
    StripeService.new.new_stripe_customer(self)
  end
end
