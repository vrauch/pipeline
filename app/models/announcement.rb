class Announcement < ActiveRecord::Base
  enum send_to: [:all_u, :startup_u, :brand_u, :selected_u]
  paginates_per 5

  belongs_to  :creator, class_name: 'User', foreign_key: :creator_id, unscoped: true
  has_many    :announcement_receivers
  has_many    :startups, through: :announcement_receivers
  has_many    :brands, through: :announcement_receivers

  validates :title, :content, presence: true
  validates :receiver_ids, presence: true, if: :sent_to_user?

  mount_uploader :cover, AnnouncementPictureUploader

  after_create :save_recievers

  attr_accessor :receiver_ids

  scope :user_announcement, -> (user) do
    if user.evo_team?
      includes(:creator, :announcement_receivers, :startups, :brands)
          .order(created_at: :desc)
    elsif user.startup?
      joins(:announcement_receivers)
          .where(announcement_receivers: { receiver_type: 0, receiver_id:  user.startup.id })
          .includes(:creator).order(created_at: :desc)
    else
      joins(:announcement_receivers)
          .where(announcement_receivers: { receiver_type: 1, receiver_id: user.brand.id })
          .includes(:creator).order(created_at: :desc)
    end
  end

  scope :get_announcement, -> (user, id) do
    if user.evo_team?
      includes(:startups, :brands).where(id: id).first
    elsif user.startup?
      joins(:announcement_receivers)
          .where(announcement_receivers: {
                 receiver_type: 0,
                 receiver_id:  user.startup.id }, id: id).first
    else
      joins(:announcement_receivers)
          .where(announcement_receivers: {
                 receiver_type: 1,
                 receiver_id:  user.brand.id }, id: id).first
    end
  end

  scope :undelivered, -> { where(delivered: nil) }

  def find_receivers
    @startups = []
    @brands = []
    case send_to
      when 'all_u'
        # @startups = Startup.where.not(owner_id: nil)
        @brands = Brand.all.includes(:users)
      when 'startup_u'
        @startups = Startup.where.not(owner_id: nil)
      when 'brand_u'
        @brands = Brand.all.includes(:users)
    end
    save_reciver_details
  end

  protected

  def sent_to_user?
    self.selected_u?
  end

  def save_recievers
    if sent_to_user?
      startup = []
      brand = []
      receiver_ids.each do |receiver|
        t, id = receiver.split('=')
        if t == '0'
          startup << id.to_i
        else
          brand << id.to_i
        end
      end
      @startups = Startup.where(id: startup).includes(:owner)
      @brands = Brand.where(id: brand).includes(:users)
      save_reciver_details
    end
  end

  def save_reciver_details
    # @startups.each do |startup|
    #   AnnouncementReceiver.create(
    #       announcement_id: self.id,
    #       receiver_type: 0,
    #       receiver_id: startup.id,
    #       user_ids: [startup.owner_id]
    #   )
    # end
    @brands.each do |brand|
      if brand.users.any?
        AnnouncementReceiver.create(
            announcement_id: self.id,
            receiver_type: 1,
            receiver_id: brand.id,
            user_ids: brand.users.pluck(:id)
        )
      end
    end
    self.update_column(:delivered, true)
    sending_announcement_activity
  end

  def sending_announcement_activity
    user = self.creator
    receivers_array = @startups.pluck(:title) + @brands.pluck(:title)
    receivers = scrape_receivers(receivers_array)
    brand_activities = []
    activity = Activity.find_by(alias: 'm_mv_post_was_sent')

    evo_text = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                      replaces: ['{{user_name}}', '{{post_name}}', '{{users}}'],
                                      replacements: [user.full_name, self.title, receivers])
    brand_text = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern] },
                                        replaces: ['{{post_name}}'],
                                        replacements: [self.title])
    evo_activity = [UserActivity.new(user: user, activity: activity, evo_text: evo_text[:evo])]
    @brands.each do |brand|
      brand_activities << UserActivity.new(user: user, activity: activity, 
                                           brand_text: brand_text[:brand],
                                           resource_type: :brand,
                                           resource_id: brand.id,
                                           evo_logo: true)
    end
    activities = brand_activities + evo_activity
    UserActivity.import activities
    sending_emails_about_activities
  end

  def sending_emails_about_activities
    BrandMailer.announcement_received(@brands, self).deliver_now
    StartupMailer.announcement_received(@startups, self).deliver_now
  end

  def scrape_receivers(users)
    case
    when all_u?
      'All Users'
    when brand_u?
      'All Brands'
    when startup_u?
      'All Startups'
    else
      users.join(', ')
    end
  end
end