class NoteCommentService

  def initialize(comment)
    @comment = comment
  end

  def adding_comment_activity(current_user)
    activity_alias = current_user.evo_team? ? 'evo_commented_note' : 'brand_commented_note'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note_text}}', '{{note_type}}',
                   '{{comment_text}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @comment.note.note_text,
                       @comment.note.assignee_id? ? 'task' : 'comment',
                       @comment.body, @comment.note.startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def editing_comment_activity(current_user)
    activity_alias = current_user.evo_team? ? 'evo_edited_comment_note' : 'brand_edited_comment_note'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note_text}}', '{{note_type}}',
                   '{{comment_text}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @comment.note.note_text,
                       @comment.note.assignee_id? ? 'task' : 'comment',
                       @comment.body, @comment.note.startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end

  def deleting_comment_activity(current_user)
    activity_alias = current_user.evo_team? ? 'evo_deleted_comment_note' : 'brand_deleted_comment_note'
    activity = Activity.find_by(alias: activity_alias)

    texts = Activity.prepare_texts(
        patterns: { brand: activity[:brand_pattern], evo: activity[:evo_pattern] },
        replaces: ['{{user_name}}', '{{note_text}}', '{{note_type}}',
                   '{{comment_text}}', '{{startup_name}}'],
        replacements: [current_user.full_name, @comment.note.note_text,
                       @comment.note.assignee_id? ? 'task' : 'comment',
                       @comment.body, @comment.note.startup.title])

    UserActivity.create(user: current_user, activity: activity,
                        evo_text: texts[:evo], brand_text: texts[:brand])
  end
end
