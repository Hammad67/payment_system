require 'spec_helper'
require 'rails_helper'
require 'vcr'
require 'webmock'
RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { FactoryBot.create(:buyer) }
  let!(:plan) { FactoryBot.create(:plan) }
  before do
    sign_in user
  end

  describe 'StripeCustomer' do
    let!(:customer) do
      cust = Stripe::Customer.create({
                                       description: 'My First Test Customer (created for API docs at https://www.stripe.com/docs/api)'
                                     })
    end
  end
end
