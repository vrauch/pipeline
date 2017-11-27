FactoryGirl.define do
  factory :note_comment do
    note nil
    author_id 1
    body "MyText"
  end
end
