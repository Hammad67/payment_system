require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should have_many(:transactions).dependent(:destroy) }
    it { should belong_to(:plan) }
    it { should belong_to(:buyer) }
  end
end
