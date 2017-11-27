FactoryGirl.define do
  factory :list do
    sequence(:name) { |n| "List-#{n}" } 
    author_id nil
    favorite false
  end
end
