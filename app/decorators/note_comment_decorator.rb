class NoteCommentDecorator < Draper::Decorator
  delegate_all

  def author_photo
    author.photo? ? h.image_tag(author.photo.thumb_medium, width: 82, alt: 'Avatar')
                  : h.image_tag('layout/user_mask.png', alt: 'Avatar')
  end

  def added_at
    created_at.strftime("%B #{created_at.day.ordinalize}, %Y %I:%M %p")
  end

end
