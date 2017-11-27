class NoteCommentsController < ApplicationController
  before_action :set_comment, except: [:create]

  def create
    @note = Note.includes(:comments).find_by(id: params[:note_id])
    @comment = NoteComment.new(comment_params).decorate
    if @comment.save
      NoteCommentService.new(@comment).adding_comment_activity(current_user)
    end
  end

  def update
    if @comment.update(comment_params)
      @comment = @comment.decorate
      NoteCommentService.new(@comment).editing_comment_activity(current_user)
      text = @comment.note.assignee_id? ? 'Task was updated' : 'Comment was updated'
      flash.now[:notice] = { title: 'Done', text: text }
    end
  end

  def destroy
    if @comment.destroy
      NoteCommentService.new(@comment).deleting_comment_activity(current_user)
      flash.now[:notice] = { title: 'Done', text: 'Has been successfully deleted' }
    end
  end

  private

  def set_comment
    @comment = NoteComment.find_by_id(params[:id])
  end

  def comment_params
    params.require(:note_comment).permit(:body)
          .merge(author_id: current_user.id, note_id: params[:note_id])
  end
end
