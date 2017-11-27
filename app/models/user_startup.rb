class UserStartup < User
  validates :email, presence: true,
                    format: { with: Devise.email_regexp },
                    uniqueness: true,
                    if: :startup_without_token?
  validate :email_uniqueness, if: :startup_without_token?

  before_save :skip_confirmation

  protected
  def skip_confirmation
    self.skip_confirmation! unless startup_without_token?
  end

  def startup_without_token?
    invite_token_id.nil?
  end

  def email_uniqueness
    if Invite.find_by(email: email)
      errors.add(:email, 'invite has already been sent on this email. Please check your inbox')
    end
  end
end