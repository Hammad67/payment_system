require 'rails_helper'

describe FeaturePolicy do
  subject { FeaturePolicy }

  permissions :index?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access to Buyer' do
      expect(subject).not_to permit(FactoryBot.create(:buyer))
    end
  end
  permissions :show? do
    it 'denies access to Admin' do
      expect(subject).not_to permit(FactoryBot.create(:admin))
    end
   end
end
