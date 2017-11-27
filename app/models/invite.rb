class Invite < ActiveRecord::Base
  include Roles
  attr_accessor :user_group
  attr_accessor :user_name

  acts_as_paranoid

  has_one :user, foreign_key: :invite_token_id
  belongs_to :sender, foreign_key: :sent_by, class_name: 'User'
  belongs_to :brand, foreign_key: :resource_id
  belongs_to :startup, foreign_key: :resource_id

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: Devise.email_regexp }
  validate :email_uniqueness
  validates_uniqueness_of :role, scope: [:resource_id], if: :role_startup?

  before_save :set_invite_token
  after_save :send_invite


  protected

  def role_startup?
    self.startup?
  end

  def set_invite_token
    self.token = generate_invite_token!
  end

  def generate_invite_token!
    loop do
      invite_token = Devise.friendly_token
      break invite_token unless self.class.exists?(token: invite_token)
    end
  end

  def email_uniqueness
    if User.find_by(email: email)
      errors.add(:email, 'has already been taken')
    end
  end

  def send_invite

    if self.brand_team?
      InviteMailer.invite_brand(self).deliver_now
    elsif self.evo_team?
      InviteMailer.invite_evo(self).deliver_now
    else
      InviteMailer.invite_startup(self).deliver_now
    end
  end
end
