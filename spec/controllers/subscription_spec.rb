require 'rails_helper'
require 'stripe_mock'
RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { FactoryBot.create(:buyer) }
  let!(:plan) { FactoryBot.create(:plan) }
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }
  before do
    sign_in user
  end

  describe 'Subscription Creation and Cancel' do
    it 'creates a stripe customer with source plan and subscription' do
      customer = Stripe::Customer.create({
                                           email: 'johnny@appleseed.com',
                                           card: stripe_helper.generate_card_token
                                         })
      expect(customer.email).to eq('johnny@appleseed.com')

      user.update(stripe_cust_id: customer.id.to_s)

      cust_card_source = Stripe::Customer.create({
                                                   source: customer.card.to_s
                                                 })
      user.update(stripe_source_id: customer.card.to_s)

      plans = stripe_helper.create_plan(id: 'my_plan', amount: 1500)
      expect(plans.id).to eq('my_plan')
      expect(plans.amount).to eq(1500)

      subscription = Stripe::Subscription.create({
                                                   customer: cust_card_source.id,
                                                   items: [{ plan: 'my_plan' }],
                                                   metadata: { foo: 'bar', example: 'yes' }
                                                 })
      post :create,
           params: { subscription: { stripe_subscription_id: subscription.id.to_s, plan_id: plan.id.to_s, buyer_id: user.id.to_s, start_date: Time.zone.at(subscription.current_period_start),
                                     end_date: Time.zone.at(subscription.current_period_end) } }
      expect(response.status).to eq(200)

      @subscriptions = Subscription.create(stripe_subscription_id: subscription.id.to_s, plan_id: plan.id.to_s, buyer_id: user.id.to_s, start_date: '',
                                           end_date: '')
      @transactions = Transaction.create(billing_day: @subscriptions.end_date,
                                         plan_id: plan.id.to_s, buyer_id: user.id.to_s)

      cancel_subscription = Stripe::Subscription.update(
        subscription.id.to_s,
        {
          cancel_at_period_end: true
        }
      )
      patch :update,
            params: { id: @subscriptions.id,
                      subscription: { is_active: false, end_date: Time.zone.at(cancel_subscription.canceled_at) } }
      expect(response.status).to eq(302)

      get :show, params: { id: @subscriptions.id }
      expect(response.status).to eq(200)
    end
  end

  describe 'create Source Request' do
    it 'creates a stripe customer with source plan and subscription' do
      customer = Stripe::Customer.create({ email: 'johnny@appleseed.com' })
      user.update(stripe_cust_id: customer.id.to_s, stripe_source_id: nil)
      # stripe_plan = stripe_helper.create_plan(id: plan.id, amount: plan.monthly_fee)
      stripe_plan = stripe_helper.create_plan(id: 'my_plan', amount: 1500)
      plan.update(stripe_plan_id: stripe_plan.id)

      post :create, params: { plan_id: plan.id, stripeToken: stripe_helper.generate_card_token }
      expect(response.status).to eq(302)
    end
  end
  describe 'GET new' do
    it 'New Action is running succefully with template' do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe 'GET index' do
    it 'Index Action is running succefully with template' do
      get :index
      expect(response.status).to eq(200)
    end
  end
  describe 'Mock card Invalid Tokken' do
    it 'Mocks stripe card Error' do
      customer = Stripe::Customer.create({ email: 'johnny@appleseed.com' })
      user.update(stripe_cust_id: customer.id.to_s, stripe_source_id: nil)
      stripe_plan = stripe_helper.create_plan(id: 'my_plan', amount: 1500)
      plan.update(stripe_plan_id: stripe_plan.id)
      tokken = Stripe::Token.create({
                                      card: {
                                        number: '4000000000009995',
                                        exp_month: 6,
                                        exp_year: 2023,
                                        cvc: '314'
                                      }
                                    })

      post :create, params: { plan_id: plan.id, stripeToken: tokken.id.to_s }

    rescue Stripe::CardError => e
      expect(e.http_status).to eq(402)
      expect(e.code).to eq('card_declined')
      expect(response.status).to eq(302)
    end
  end
end
