FactoryGirl.define do
  factory :note do
    author_id 1
    note_text "MyText"
    due_date "2016-03-28"
    assignee_id 1
    status 1
  end
end
