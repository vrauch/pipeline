ThinkingSphinx::Index.define :startup, with: :active_record do
  # fields
  indexes title, sortable: true
  indexes location, sortable: true
  indexes startup_tags.tag.title, as: :tag_titles
  indexes startup_brief_summaries.answer_text, as: :answer_text
  indexes startup_brief_summaries.brief_question.answers.category_value.content, as: :answer

  has startup_brief_summaries.brief_answer.category_value_id, as: :answer_id
  has created_at, date_founded, id
end
