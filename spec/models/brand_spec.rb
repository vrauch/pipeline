require 'rails_helper'

RSpec.describe Brand, type: :model do
  it { should have_many(:packages) }
  it { should have_many(:pictures) }
  it { should have_many(:brand_startups) }
  it { should have_many(:brand_scorecards) }
  it { should have_many(:brand_users) }
end
