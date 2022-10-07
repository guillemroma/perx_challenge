require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Update User Rewards Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = UpdateUserRewards.new(@client.id)

    expect(service.call).to eq(true)
  end

  it 'Adds free_movie_ticket if user spent during the first 60 days is greater than 1000$ and user is elegible' do
    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 1001,
      date: Date.today - 1
    )

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).free_movie_tickets).to eq(true)
  end

  it 'Does not add free_movie_ticket if user spent during the first 60 days is lower than 1000$ despite user elegible' do
    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 1001,
      date: Date.today - 100
    )

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).free_movie_tickets).to eq(false)
  end

  it 'Does not add free_movie_ticket if user spent during the first 60 days is greater than 1000$ but NOT elegible' do
    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 1001,
      date: Date.today
    )

    RewardElegible.create!(
      user_id: @client.id,
      free_movie_tickets: false
    )

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).free_movie_tickets).to eq(false)
  end

  it 'Adds cash_rebate if user top 10 transactions greater than 100$ each and user is elegible' do
    10.times do
      Transaction.create!(
        user_id: @client.id,
        country: @client.country,
        amount: 101,
        date: Date.today
      )
    end

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).cash_rebate).to eq(true)
  end

  it 'Does not add cash_rebate if any of users top 10 transaction lower than 100$ despite user elegible' do
    9.times do
      Transaction.create!(
        user_id: @client.id,
        country: @client.country,
        amount: 101,
        date: Date.today - 100
      )
    end

    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 99,
      date: Date.today - 100
    )

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).cash_rebate).to eq(false)
  end

  it 'Does not add cash_rebateif user spent during the first 60 days is greater than 1000$ but NOT elegible' do
    10.times do
      Transaction.create!(
        user_id: @client.id,
        country: @client.country,
        amount: 101,
        date: Date.today
      )
    end

    RewardElegible.create!(
      user_id: @client.id,
      cash_rebate: false
    )

    service = UpdateUserRewards.new(@client.id)
    service.call

    expect(Reward.find_by(user_id: @client.id).cash_rebate).to eq(false)
  end

end
