require 'rails_helper'
require 'json'
require 'support/factory_bot'

describe 'Transaction requests', type: :request do
  include ActiveJob::TestHelper

  before(:each) do
    @client = FactoryBot.create(:user_client)
    @corporation = FactoryBot.create(:user_corporation)
  end

  describe 'GET REQUESTS' do
    context "Transaction Index" do
      it 'returns status 200 if user authorized' do
        login_as(@corporation)
        get user_transactions_path(@client.id)

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get user_transactions_path(@client.id)

        expect(response).to(have_http_status(302))
      end
    end

    context "Transaction New" do
      it 'returns status 200 if user authorized' do
        login_as(@corporation)
        get new_user_transaction_path(@client.id)

        expect(response).to(have_http_status(200))
      end

      it 'returns status 302 if user is NOT authorized' do
        login_as(@client)
        get new_user_transaction_path(@client.id)

        expect(response).to(have_http_status(302))
      end
    end
  end

  describe 'POST REQUESTS' do
    context 'Transaction Create' do
      it 'redirects to "users_path" if transaction created' do
        login_as(@corporation)
        post user_transactions_path(
          user_id: @client.id,
          transaction: {
            amount: 100,
            date: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )

        expect(response).to(redirect_to(users_path))
        expect(enqueued_jobs.size).to eq(2)
        expect(enqueued_jobs.first[:job]).to eq(UpdateUserPointsJob)
        expect(enqueued_jobs.last[:job]).to eq(UpdateUserRewardsJob)
      end

      it 'redirects to "new_user_transaction_path" if transaction NOT created' do
        login_as(@corporation)
        post user_transactions_path(
          user_id: @client.id,
          transaction: {
            date: Faker::Date.birthday,
            country: User::COUNTRIES.sample
          }
        )

        expect(response).to(redirect_to(new_user_transaction_path(@client.id)))
      end
    end
  end
end
