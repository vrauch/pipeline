class StartupService

  def initialize(startup)
    @startup = startup
  end

  def create_full_profile(brief_params)
    if @startup.save
      StartupBriefSummary.save_answers(@startup, brief_params)
    end
  end

  def update_full_profile(startup_params, brief_params)
    if @startup.update_attributes(startup_params)
      StartupBriefSummary.update_answers(@startup, brief_params)
    end
  end

  def creating_watchlist_activity(current_user)
    activity_alias = current_user.evo_team? ? 'startup_watchlist_added_by_evo' : 'startup_watchlist_added_by_brand'
    activity = Activity.find_by(alias: activity_alias)


    texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                               evo: activity[:evo_pattern] },
                                   replaces: ['{{user_name}}', '{{startup_name}}'],
                                   replacements: [current_user.full_name, @startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def updating_watchlist_activity(current_user)
    if @startup.previous_changes.any?
      @startup.previous_changes.delete(:updated_at)
      @startup.previous_changes.delete(:updater_id)
      if @startup.owner
        activity_alias = current_user.evo_team? ? 'startup_updated_by_evo' : 'startup_updated_by_brand'
      else
        activity_alias = current_user.evo_team? ? 'startup_watchlist_updated_by_evo' : 'startup_watchlist_updated_by_brand'
      end

      activity = Activity.find_by(alias: activity_alias)
      updated = []
      @startup.previous_changes.each do |key, values|
        next if values[0].nil? && values[1] == ''
        updated << "'#{key.humanize.titleize}' from '#{values[0]}' to '#{values[1]}'"
      end

      return false if updated.empty?

      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{user_name}}', '{{updates}}', '{{startup_name}}'],
                                     replacements: [current_user.full_name, updated.join(';<br>'), @startup.title])

      UserActivity.create(user: current_user, activity: activity,
                          resource_id: @startup.id,
                          resource_type: UserActivity.resource_types[:startup],
                          evo_text: texts[:evo], brand_text: texts[:brand])
    end
  end

  def updating_profile_activity(current_user)
    return false if @startup.invalid? || !current_user.active?

    if @startup.previous_changes.any?
      @startup.previous_changes.delete(:updated_at)
      activity = Activity.find_by(alias: 'startup_edited_profile')
      updated = []
      @startup.previous_changes.each do |key, values|
        updated << "'#{key.humanize.titleize}' from '#{values[0]}' to '#{values[1]}'"
      end


      texts = Activity.prepare_texts(patterns: { brand: activity[:brand_pattern],
                                                 evo: activity[:evo_pattern] },
                                     replaces: ['{{startup_name}}', '{{updates}}'],
                                     replacements: [@startup.title, updated.join(';<br>')])

      UserActivity.create(user: current_user, activity: activity,
                          resource_id: @startup.id,
                          resource_type: UserActivity.resource_types[:startup],
                          evo_text: texts[:evo], brand_text: texts[:brand])
    end
  end

end