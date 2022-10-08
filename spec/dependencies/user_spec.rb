require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'User depedencies', type: :model do
  before(:each) do
    @client = FactoryBot.create(:user_client)

    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 1_000,
      date: Date.today
    )

    UpdateUserPoints.new(@client.id).call
    UpdateUserRewards.new(@client.id).call

    Membership.create(user_id: @client.id)
    PointRecord.create(user_id: @client.id, year: Date.today.year - 1, amount: 10_000)
    AirportLoungeControl.create(user_id: @client.id)
    TierControl.create(user_id: @client.id)
  end

  it 'When an instance of User is destroyed, everything else is' do

    @client.destroy

    expect(Transaction.count).to eq(0)
    expect(PointRecord.count).to eq(0)
    expect(Reward.count).to eq(0)
    expect(Point.count).to eq(0)
    expect(Membership.count).to eq(0)
    expect(TierControl.count).to eq(0)
    expect(AirportLoungeControl.count).to eq(0)
    expect(RewardElegible.count).to eq(0)
  end
end
