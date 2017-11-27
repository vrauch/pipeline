FactoryGirl.define do
  factory :request do
    startup_id 1
    brand nil
    author_id 1
    request_type 1
    body "MyText"
  end
end
