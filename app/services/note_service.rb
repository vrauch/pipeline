class NoteService

  def initialize(note, startup)
    @note = note
    @startup = startup
  end

  def adding_comment_activity(current_user)
    activity_alias = current_user.evo_team? ? 'note_added_by_evo' : 'note_added_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @note.note_text, @startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def adding_task_activity(current_user)
    activity_alias = current_user.evo_team? ? 'task_added_by_evo' : 'task_added_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{username}}', '{{content}}', '{{assignee_name}}', '{{due_date}}'],
        replacements: [current_user.full_name, @note.note_text, @note.assignee_full_name, @note.due_date.to_s])

    user_activity = UserActivity.create(
        user: current_user, activity: activity,
        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'Task was added', only_current: true,
                           user: @note.assignee).deliver_now
  end

  def marking_as_done_activity(current_user)
    activity_alias = current_user == @note.assignee ? 'task_completed_by_evo_self' : 'task_completed_by_evo_other'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: current_user == @note.assignee ? ['{{startup_name}}', '{{content}}', '{{author_name}}']
                                                 : ['{{startup_name}}', '{{user_name}}', '{{content}}'],
        replacements: current_user == @note.assignee ? [@note.startup.title, @note.note_text, @note.author_full_name]
                                                     : [@note.startup.title, @note.assignee_full_name,  @note.note_text])

    user_activity = UserActivity.create(
        user: current_user, activity: activity,
        evo_text: texts[:evo], brand_text: texts[:brand])

    EvoMailer.notification(user_activity, 'Task was completed', only_current: true,
                           user: @note.author).deliver_now

  end

  def editing_note_activity(current_user)
    activity_alias = current_user.evo_team? ? 'note_edited_by_evo' : 'note_edited_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    if @note.previous_changes[:note_text]
      updated = " from '#{@note.previous_changes[:note_text][0]}' to '#{@note.previous_changes[:note_text][1]}'"
    else
      return false
    end

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note_type}}', '{{updates}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @note.assignee ? 'task' : 'comment', updated, @startup.title])

    UserActivity.create(
        user: current_user, activity: activity,
        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def deleting_note_activity(current_user)
    activity_alias = current_user.evo_team? ? 'note_deleted_by_evo' : 'note_deleted_by_brand'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note_type}}', '{{note_name}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @note.assignee ? 'task' : 'comment', @note.note_text, @startup.title])

    UserActivity.create(
        user: current_user, activity: activity,
        evo_text: texts[:evo], brand_text: texts[:brand])
  end

end
