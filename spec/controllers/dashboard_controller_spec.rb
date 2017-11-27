require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #brand_questions" do
    it "returns http success" do
      get :brand_questions
      expect(response).to have_http_status(:success)
    end
  end

end
