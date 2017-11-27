class NotesController < ApplicationController
  load_and_authorize_resource

  before_action :find_note, only: [:edit, :update, :delete, :destroy,
                                   :mark_as_done, :mark_as_undone]

  before_action :find_startup, only: [:new, :create]

  def new
    @note = Note.new.decorate
  end

  def create
    @note = Note.new(note_params.merge(startup_id: @startup.id)).decorate
    if @note.save
      if @note.assignee_id?
        text = 'Task was added'
        method = :adding_task_activity
      else
        text = 'Comment was added'
        method = :adding_comment_activity
      end
      NoteService.new(@note, @startup).send(method, current_user)
      flash.now[:notice] = { title: 'Done', text: text }
    end
  end

  def update
    if @note.update_attributes(note_params)
      NoteService.new(@note, @note.startup).editing_note_activity(current_user)
      text = @note.assignee_id? ? 'Task was updated' : 'Comment was updated'
      flash.now[:notice] = { title: 'Done', text: text }
    end
  end

  def destroy
    @startup = @note.startup
    if @note.destroy
      NoteService.new(@note, @note.startup).deleting_note_activity(current_user)
      flash.now[:notice] = { title: 'Done', text: 'Has been successfully deleted' }
    end
  end

  def mark_as_done
    if @note.update_attributes(status: :done, status_changed_at: Date.today)
      NoteService.new(@note, @note.startup).marking_as_done_activity(current_user)
    end
  end

  def mark_as_undone
    @note.assigned!
  end

  private

  def note_params
    permit_params = params[:type] == Note::TASK ? [:assignee_id, :note_text, :due_date] : [:note_text]
    prms = params.require(:note).permit(permit_params).merge(author_id: current_user.id)

    if params[:note][:assignee_id].blank? && params[:type] == Note::TASK
      prms = prms.merge(assignee_id: current_user.id)
    end
    prms
  end

  def find_startup
    @startup = Startup.find_by(id: params[:startup_id])
  end

  def find_note
    @note = Note.find_by(id: params[:id]).decorate
  end
end
