class NoteDecorator < Draper::Decorator
  decorates_association :author
  decorates_association :assignee
  decorates_association :comments
  delegate_all

  def form_title
    if h.params[:type] == Note::TASK
      new_record? ? 'Add Task' : 'Edit Task'
    else
      new_record? ? 'Add Comment' : 'Edit Comment'
    end
  end

  def task_done
    done? ? 'done' : ''
  end

  def author_photo
    author.photo? ? h.image_tag(author.photo.thumb_medium, width: 82, alt: 'Avatar')
                  : h.image_tag('layout/user_mask.png', alt: 'Avatar')
  end

  def suffix
    startup && !not_add_prefix_url ? "#{startup.title} startup: " : ''
  end

  def assigned_for
    "For #{assignee.full_name}" if assignee.present?
  end

  def task_author
    "By #{author.full_name}"
  end

  def assigned_at
    created_at.strftime("%B #{created_at.day.ordinalize}, %Y %I:%M %p")
  end

  def date_fail
    'date_fail' if due_date.present? && due_date < Date.today
  end

  def due_date_at
    "Due: #{due_date.strftime('%b %d')}" if due_date.present?
  end

  def mark_unmark_url
    done? ? h.mark_as_undone_note_path(model) : h.mark_as_done_note_path(model)
  end

  def editable_or_done
    if done?
      h.content_tag :div, class: 'task_result' do
        h.content_tag :span do
          "Done: #{status_changed_at.strftime('%B %d')}"
        end
      end
    else
      if h.can? :update, model
        h.link_to 'Edit', h.edit_note_path(model, type: assignee ? 'task' : 'comment'),
                  class: 'edit_panel_item', remote: true
      end
    end
  end

  def task?
    assignee.present? ? 'panel_task' : ''
  end

  def placeholder
    h.params[:type] == Note::TASK ? 'task' : 'comment'
  end

  def height
    h.params[:type] == Note::TASK ? '215px' : '315px'
  end

  private

  def not_add_prefix_url
    h.params[:action] == 'create' || h.params[:action] == 'tasks'
  end

end
