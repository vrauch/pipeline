class UserActivity < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :user, unscoped: true
  belongs_to :activity
  belongs_to :startup, foreign_key: :resource_id
  belongs_to :brand, foreign_key: :resource_id

  # Guest - 0, Startup User - 1, Brand Team User - 2, Brand Team Super User - 3
  # Evo Team User - 4, Evo Team Super User - 5
  enum resource_type: [:startup, :brand]


  delegate :photo, to: :user, prefix: true
  delegate :full_name, to: :user, prefix: true
  delegate :logo, to: :startup, prefix: true
  delegate :title, to: :startup, prefix: true
  delegate :logo, to: :brand, prefix: true

  scope :updates, -> { joins(:activity).where(:'activities.updates' => true)
                                       .where.not(evo_text: nil).includes(:user) }

  scope :brand_logins, -> do
     joins(:activity).where(activities: { alias: 'brand_login' },
                            created_at: 1.month.ago..DateTime.now).count(:id)
  end

  scope :brand_activities, ->(user) do
    startup_ids = Startup.founder(user).pluck(:id)
    includes(:user).joins(:activity).where('user_id IN (:brand_user_ids) OR resource_type = :type_brand AND resource_id = :brand_id
         OR resource_type = :type_startup AND resource_id IN (:startup_ids)',
    { brand_user_ids: user.brand_user_ids, type_brand: resource_types[:brand],
      type_startup: resource_types[:startup], brand_id: user.brand_id,
      startup_ids: startup_ids }).where.not(brand_text: nil, activities: { alias: ['brand_login'] })
  end
  scope :evo_activities, -> { joins(:activity).where.not(evo_text: nil, activities: { alias: ['evo_login'] }) }

  scope :startup_activities, ->(startup_id) { where(resource_type: resource_types[:startup],
                                                    resource_id: startup_id) }
  # scope :without_evo_logins, -> { evo_activities.joins(:activity).where.not(activities: { alias: ['evo_login'] }) }
  # scope :without_brand_logins, ->(user) { brand_activities(user).joins(:activity)
  #                                             .where.not(activities: { alias: ['brand_login'] }) }
  scope :brand_user_activities, -> (user_id) { where(user_id: user_id).joins(:activity)
                                              .where(:'activities.super_only' => false) }

end
