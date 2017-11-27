require 'rails_helper'

RSpec.describe Package, type: :model do
  it { should have_many(:brands) }
  it { should validate_presence_of(:name) }
  it do
    should validate_numericality_of(:number_brand_briefs)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_external_pages)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_users)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_questions)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_startups)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_scorecards)
      .only_integer.is_greater_than_or_equal_to(0)
  end
  it do
    should validate_numericality_of(:number_scorecard_requests)
      .only_integer.is_greater_than_or_equal_to(0)
  end
end
