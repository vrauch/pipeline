class StartupTagsController < ApplicationController

  before_action :set_startup
  after_action :creating_tags_activity, only: [:create]

  def index
    user_ids = current_user.evo_team? ? User.evo_users.pluck(:id)
                                      : current_user.brand_user_ids
    @tags = Tag.preload(:tags).where(Tag.arel_table[:title].matches("%#{params[:query]}%"))
               .where(user_id: user_ids)
               .where.not(id: @startup.tags.ids).pluck(:title)
    render json: @tags
  end

  def create
    @tags = Tag.save_tags(params[:tag], current_user)

    @tags.each do |tag|
      @startup.startup_tags.create(startup: @startup, tag: tag)
    end
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  def destroy
    user_ids = current_user.evo_team? ? User.evo_users.pluck(:id) : current_user.brand_user_ids
    @tag = Tag.find_by(alias: params[:id].downcase.underscore, user_id: user_ids)
    @startup.tags.delete(@tag)
    @startup_tags = StartupTag.startup_tags(@startup.id, current_user.team_mate_ids)
  end

  private

  def set_startup
    @startup = Startup.find_by(id: params[:startup_id])
  end

  def creating_tags_activity
    activity = Activity.find_by(alias: current_user.brand_team? ? 'tag_added_by_brand' : 'tag_added_by_evo')

    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{tag_name}}', '{{startup_name}}'],
                                   replacements: [current_user.full_name, @tags.map(&:title).join(', '), @startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

end
