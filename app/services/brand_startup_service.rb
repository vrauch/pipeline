class BrandStartupService

  def initialize(brand, startup)
    @brand = brand
    @startup = startup
  end

  def pushing_startup_activity(current_user)
    activity = Activity.find_by(alias: 'startup_pushed')

    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{startup_name}}', '{{brand_name}}'],
                                   replacements: [current_user.full_name, @startup.title, @brand.title])

    user_activity = UserActivity.create(user: current_user, activity: activity,
                                        resource_id: @brand.id,
                                        resource_type: UserActivity.resource_types[:brand],
                                        evo_text: texts[:evo], brand_text: texts[:brand], evo_logo: true)

    BrandMailer.startup_pushed(user_activity, @brand).deliver_now
  end

  def deleting_startup_activity(current_user)
    activity = Activity.find_by(alias: 'evo_canceled_push')

    texts = Activity.prepare_texts(patterns: { evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{startup_name}}', '{{brand_name}}'],
                                   replacements: [current_user.full_name, @startup.title, @brand.title])

    user_activity = UserActivity.create(user: current_user, activity: activity,
                                        resource_id: @brand.id,
                                        resource_type: UserActivity.resource_types[:brand],
                                        evo_text: texts[:evo], brand_text: texts[:brand], evo_logo: true)

    BrandMailer.startup_pushed(user_activity, @brand).deliver_now
  end

end