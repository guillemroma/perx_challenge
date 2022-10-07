require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'update Airport Lounge Access Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
    Reward.create(
      user_id: @client.id,
      free_coffee: true,
      cash_rebate: true,
      free_movie_tickets: true,
      airport_lounge_access: true
    )

    RewardElegible.create(
      user_id: @client.id,
      free_coffee: true,
      cash_rebate: true,
      free_movie_tickets: true,
      airport_lounge_access: true
    )
  end

  it 'returns true if successfully implemented' do
    service = UpdateAirportLoungeAccess.new(@client.id, Reward.find_by(user_id: @client.id))

    expect(service.call).to eq(true)
  end

  it 'creates an Airpot Lounge Control record if it does not exists' do
    service = UpdateAirportLoungeAccess.new(@client.id, Reward.find_by(user_id: @client.id))

    service.call
    expect(AirportLoungeControl.count).to eq(1)
  end

  it 'reduces remaining by one every time it is called' do
    AirportLoungeControl.create(user_id: @client.id)
    airport_lounge_control_remaining = AirportLoungeControl.find_by(user_id: @client.id).remaining

    service = UpdateAirportLoungeAccess.new(@client.id, Reward.find_by(user_id: @client.id))

    service.call
    expect(AirportLoungeControl.find_by(user_id: @client.id).remaining).to eq(airport_lounge_control_remaining - 1)
  end

  it 'sets Airport Lounge Access to false if remaining is 0' do
    4.times do
      service = UpdateAirportLoungeAccess.new(@client.id, Reward.find_by(user_id: @client.id))

      service.call
    end

    expect(Reward.find_by(user_id: @client.id).airport_lounge_access).to eq(false)
  end
end
