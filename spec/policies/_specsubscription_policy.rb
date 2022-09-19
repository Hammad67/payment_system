require 'rails_helper'

describe SubscriptionPolicy do
  subject { SubscriptionPolicy }

  permissions :show?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access to Buyer' do
      expect(subject).not_to permit(FactoryBot.create(:admin))
    end
  end
  permissions :index? do
    it 'denies access to Admin' do 
      expect(subject).not_to permit(FactoryBot.create(:buyer))
    end
   end
end
