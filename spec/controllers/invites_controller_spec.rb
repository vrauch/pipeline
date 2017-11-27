require 'rails_helper'

RSpec.describe InvitesController, type: :controller do

  describe 'GET #new' do
    before(:each) do
      sign_in create(:user, :evo_super)
    end
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:new)
    end
  end

end
