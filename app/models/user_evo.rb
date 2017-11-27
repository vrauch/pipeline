class UserEvo < User
  validates :photo, file_size: { maximum: 2.megabyte.to_i }
  validates :email, presence: true,
            format: { with: Devise.email_regexp },
            uniqueness: true,
            on: :update

  before_save :skip_confirmation
  before_save :activate

  private
  def activate
    self.active = 1 if new_record?
  end

end