class ActivityService

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end


  def save_request(request)
    activity = Activity.find_by(alias: 'brand_sent_request')
    brand = @current_user.brand || @brand

    texts = Activity.prepare_texts(
      patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
      replaces: %w|{{user_name}} {{brand_name}} {{request_text}}|,
      replacements: [@current_user.full_name, brand.try(:title),
                     request.body]
    )

    user_activity = UserActivity.create(
      user: @current_user, activity: activity,
      resource_id: brand.try(:id),
      resource_type: UserActivity.resource_types[:brand],
      evo_text: texts[:evo], brand_text: texts[:brand]
    )

    EvoMailer.notification(user_activity, 'New request').deliver_now
  end

  def save_scorecard_request(request)
    activity = Activity.find_by(alias: 'brand_requested_scorecard')

    texts = Activity.prepare_texts(
      patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
      replaces: %w|{{brand_name}} {{startup_name}}|,
      replacements: [@current_user.brand.title, request.startup.title]
    )

    user_activity = UserActivity.create(
      user: @current_user, activity: activity,
      resource_id: @current_user.brand.id,
      resource_type: UserActivity.resource_types[:brand],
      evo_text: texts[:evo], brand_text: texts[:brand]
    )

    EvoMailer.notification(user_activity, 'New scorecard request').deliver_now
  end

  def save_answer_request(request)
    activity = Activity.find_by(alias: 'evo_answered_on_request')

    texts = Activity.prepare_texts(
      patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
      replaces: %w|{{user_name}} {{author_name}} {{brand_name}} {{request_text}} {{answer_text}}|,
      replacements: [@current_user.full_name, request.author_full_name,
                     request.brand_title, request.body, request.answer_body]
    )

    user_activity = UserActivity.create(
      user: current_user, activity: activity,
      resource_type: UserActivity.resource_types[:brand],
      resource_id: request.brand_id,
      evo_text: texts[:evo], brand_text: texts[:brand], evo_logo: true)

    BrandMailer.request_answer(user_activity, request.answer).deliver_now
  end

  def send_scorecard(scorecard)
    activity = Activity.find_by(alias: 'scorecard_sent')

    texts = Activity.prepare_texts(
      patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
      replaces: %w|{{startup_name}} {{brand_name}}|,
      replacements: [scorecard.startup.try(:title), scorecard.brand.try(:title)]
    )

    user_activity = UserActivity.create(
      user: current_user, activity: activity,
      resource_type: UserActivity.resource_types[:brand],
      resource_id: scorecard.brand.try(:id),
      evo_text: texts[:evo], brand_text: texts[:brand], evo_logo: true)

    BrandMailer.scorecard_pushed(user_activity, scorecard.brand).deliver_now
  end
end
