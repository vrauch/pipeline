class StartupProfileQuestion < ActiveRecord::Base
  belongs_to :user, unscoped: true
  belongs_to :startup
  has_one    :answer, foreign_key: :startup_profile_question_id,
                       class_name: 'StartupProfileAnswer'

  accepts_nested_attributes_for :answer, reject_if: :all_blank, 
                                          allow_destroy: true

  validates :body, presence: true

  scope :new_requests, ->  { where(answered: false) }

  class << self
    def send_request(params)
      brand = params[:brand]
      startup = params[:startup]
      user = params[:user]
      brand_title = brand.title.titleize
      link = params[:link]
      url = "We think you may be a great fit for #{brand_title}!<br>
            Before we share your profile, please answer these #{brand_title} specific
            questions <a href='#{link}' class='pink_link'>here</a>. Respond to us in the field below
            to confirm when you have completed these questions."
      self.create(body: url, title: 'Startup Brand Brief', user: user,
                  startup: startup)
    end
  end

end
