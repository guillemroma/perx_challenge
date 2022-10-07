require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Spend Rewards Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
    Reward.create(
      user_id: @client.id,
      free_coffee: true,
      cash_rebate: true,
      free_movie_tickets: true,
      airport_lounge_access: true
    )

    AirportLoungeControl.create(user_id: @client.id)

    RewardElegible.create(
      user_id: @client.id,
      free_coffee: true,
      cash_rebate: true,
      free_movie_tickets: true,
      airport_lounge_access: true
    )
  end

  it 'returns true if successfully implemented' do
    service = SpendRewards.new(
      user_id: @client.id,
      reward_type: "free_coffee"
    )

    expect(service.call).to eq(true)
  end

  it 'spends a reward if user is elegible to spend it' do
    service = SpendRewards.new(
      user_id: @client.id,
      reward_type: "free_coffee"
    )
    service.call

    expect(Reward.find_by(user_id: @client.id).free_coffee).to eq(false)
  end

  it 'reduces Airport Lounge by 1 unit if airport lounge is used' do
    airport_lounge_control_remaining = AirportLoungeControl.find_by(user_id: @client.id).remaining

    service = SpendRewards.new(
      user_id: @client.id,
      reward_type: "airport_lounge_access"
    )

    service.call
    expect(AirportLoungeControl.find_by(user_id: @client.id).remaining).to eq(airport_lounge_control_remaining - 1)
  end

  it 'does not set Airport Lounge Access to false if called less than 4 times' do
    2.times do
      service = SpendRewards.new(
        user_id: @client.id,
        reward_type: "airport_lounge_access"
      )
      service.call
    end

    expect(Reward.find_by(user_id: @client.id).airport_lounge_access).to eq(true)
  end

  it 'sets Airport Lounge Access to false if called 4 times' do
    4.times do
      service = SpendRewards.new(
        user_id: @client.id,
        reward_type: "airport_lounge_access"
      )
      service.call
    end

    expect(Reward.find_by(user_id: @client.id).airport_lounge_access).to eq(false)
  end
end
