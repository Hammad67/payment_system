require 'rails_helper'
require 'faker'
require_relative '../support/devise'

RSpec.describe FeaturesController, type: :controller do
  let!(:user) { FactoryBot.create(:admin) }
  let!(:feature) { FactoryBot.create(:feature) }
  before do
    sign_in user
  end

  describe 'GET index' do
    it 'Index Action is running succefully with template' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'Create action will ' do
    it 'will redirect to show action' do
      post :create,
           params: { feature: { name: feature.name.to_s, code: feature.code.to_s, unit_price: feature.unit_price.to_s,
                                max_unit_limit: feature.max_unit_limit.to_s } }

      expect(response.status).to eq(302)
    end

    it 'will render the new action again' do
      post :create,
           params: { feature: { name: '', code: '', unit_price: '',
                                max_unit_limit: '' } }

      expect(response.status).to eq(422)
    end
  end

  describe 'GET show' do
    it 'Show action is executing successfully with template' do
      get :show, params: { id: feature.id }
      expect(response.status).to eq(200)
    end
  end
  describe 'GET Edit' do
    it 'Update action is executing successfully with template' do
      get :edit, params: { id: feature.id }
      expect(response.status).to eq(200)
    end
  end
  describe 'PATCH update' do
    it 'Updates the feature and redirects' do
      patch :update,
            params: { id: feature.id,
                      feature: { name: 'ultra pro max hd s', code: 'anytgghingê3233', unit_price: '110',
                                 max_unit_limit: '889' } }
      expect(response).to be_redirect
    end
    it 'will not update the feature and redirects' do
      patch :update,
            params: { id: feature.id,
                      feature: { name: '', code: 'a', unit_price: '1',
                                 max_unit_limit: '' } }
      expect(response.status).to eq(422)
    end
  end
  describe 'DELETE #destroy' do
    context 'success' do
      it 'deletes the user' do
        expect do
          delete :destroy, params: { id: feature.id }
        end.to change(Feature, :count).by(-1)
      end
    end
  end
end
