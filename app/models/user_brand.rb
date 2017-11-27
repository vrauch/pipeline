class UserBrand < User

  validates :photo, file_size: { maximum: 2.megabyte.to_i }
  validates :email, presence: true,
                    format: { with: Devise.email_regexp },
                    uniqueness: true,
                    on: :update

  before_save :skip_confirmation
end