require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  describe 'GET new' do
    it 'New Action is running succefully with template' do
      get :new
      expect(response.status).to eq(302)
    end
  end
end
