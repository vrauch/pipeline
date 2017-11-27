FactoryGirl.define do
  factory :user do
    sequence(:full_name) { |n| "Ivane-#{n}" } 
    sequence(:email) { |n| "bububu#{n}@gmail.com" }
    password "password"
    password_confirmation "password"
    role 0
    active 1
    trait :startup do
      role 1
    end
    trait :brand do
      role 2
    end
    trait :brand_super do
      role 3
    end
    trait :evo do
      role 4
    end
    trait :evo_super do
      role 5
    end
    after(:create) do |user|
      create(:list, author_id: user.id, favorite: true)
    end
  end

end
