require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Check Quarterly Spent Service', type: :service do
  before(:each) do
    @money = FactoryBot.create(:user_client, email: "test@test.com", birthday: Date.today)
    @cheap = FactoryBot.create(:user_client, email: "test1@test.com", birthday: Date.today - 1)

    Transaction.create!(
      user_id: @money.id,
      country: @money.country,
      amount: 1_000_000,
      date: Date.today
    )

    UpdateUserPoints.new(@money.id).call
    UpdateUserRewards.new(@money.id).call

    Transaction.create!(
      user_id: @cheap.id,
      country: @cheap.country,
      amount: 1_000_000,
      date: Date.today - 100
    )

    UpdateUserPoints.new(@cheap.id).call
    UpdateUserRewards.new(@cheap.id).call
  end

  it 'returns true if successfully implemented' do
    service = CheckQuarterlySpent.new

    expect(service.call).to eq(true)
  end

  it 'adds 100 points if user has spent + 2000 in one quarter' do
    service = CheckQuarterlySpent.new
    intitial_points = Point.find_by(user_id: @money.id).amount
    service.call

    expect(Point.find_by(user_id: @money.id).amount).to be(intitial_points + 100)
  end

  it 'does NOT add 100 points if user has spent less than 2000 in one quarter' do
    service = CheckQuarterlySpent.new
    intitial_points = Point.find_by(user_id: @cheap.id).amount
    service.call

    expect(Point.find_by(user_id: @cheap.id).amount).to be(intitial_points)
  end
end
