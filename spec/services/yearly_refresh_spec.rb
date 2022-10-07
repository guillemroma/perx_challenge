require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Yearly Refresh Service', type: :service do
  before(:each) do
    @money = FactoryBot.create(:user_client, email: "test@test.com", birthday: Date.today)
    @cheap = FactoryBot.create(:user_client, email: "test1@test.com", birthday: Date.today - 1)

    Transaction.create!(
      user_id: @money.id,
      country: @money.country,
      amount: 10_100,
      date: Date.today
    )

    UpdateUserPoints.new(@money.id).call
    UpdateUserRewards.new(@money.id).call

    Transaction.create!(
      user_id: @cheap.id,
      country: @cheap.country,
      amount: 10,
      date: Date.today - 100
    )

    UpdateUserPoints.new(@cheap.id).call
    UpdateUserRewards.new(@cheap.id).call

    PointRecord.create!(
      user_id: @money.id,
      year: 2003,
      amount: 100
    )

    RewardElegible.create!(
      user_id: @money.id,
      free_movie_tickets: false,
      free_coffee: false,
      cash_rebate: false,
      airport_lounge_access: false
    )

    TierControl.create!(user_id: @money.id)
    TierControl.create!(user_id: @cheap.id)
  end

  it 'returns true if successfully implemented' do
    service = YearlyRefresh.new

    expect(service.call).to eq(true)
  end

  it 'destroy old Ppoint Records' do
    service = YearlyRefresh.new
    service.call

    expect(PointRecord.where(user_id: @money.id, year: 2003).count).to be(0)
  end

  it 'resets Reward Eelegible (except for free_movie_tickets)' do
    service = YearlyRefresh.new
    service.call

    expect(RewardElegible.find_by(user_id: @money.id).free_coffee).to be(true)
    expect(RewardElegible.find_by(user_id: @money.id).cash_rebate).to be(true)
    expect(RewardElegible.find_by(user_id: @money.id).airport_lounge_access).to be(true)

    expect(RewardElegible.find_by(user_id: @money.id).free_movie_tickets).to be(false)
  end

  it 'creates / updates current year Point Record and resets Points' do
    points_current_year = Point.find_by(user_id: @money.id).amount
    service = YearlyRefresh.new
    service.call

    expect(PointRecord.where(user_id: @money.id, year: Date.today.year).first.amount).to be(points_current_year)
    expect(Point.find_by(user_id: @money.id).amount).to be(0)
  end

  it 'updates to Gold tier if user has > 1000 points  (in the last 2 cycles)' do
    service = YearlyRefresh.new
    service.call

    expect(TierControl.find_by(user_id: @money.id).current_year).to eq("gold")
    expect(Membership.find_by(user_id: @money.id).gold).to be(true)
  end

  it 'updates to Platinium tier if user has > 5000 points (in the last 2 cycles)' do
    Transaction.create!(
      user_id: @money.id,
      country: @money.country,
      amount: 1_000_000,
      date: Date.today
    )

    UpdateUserPoints.new(@money.id).call

    service = YearlyRefresh.new
    service.call

    expect(TierControl.find_by(user_id: @money.id).current_year).to eq("platinium")
    expect(Membership.find_by(user_id: @money.id).platinium).to be(true)
  end

  it 'updates airport lounge acces reward if client was Standard and turns Gold' do
    service = YearlyRefresh.new
    service.call

    expect(Reward.find_by(user_id: @money.id).airport_lounge_access).to eq(true)
  end

  it 'does NOT update airport lounge acces reward if client was Standard and turns Platinium' do
    Transaction.create!(
      user_id: @money.id,
      country: @money.country,
      amount: 1_000_000,
      date: Date.today
    )

    UpdateUserPoints.new(@money.id).call

    service = YearlyRefresh.new
    service.call

    expect(Reward.find_by(user_id: @money.id).airport_lounge_access).to eq(false)
  end

  it 'does NOT updates airport lounge acces reward if client was Standard and remains Standard' do
    @other_user = FactoryBot.create(:user_client, email: "test2@test.com")
    TierControl.create!(user_id: @other_user.id)

    service = YearlyRefresh.new
    service.call

    expect(Reward.find_by(user_id: @other_user.id).airport_lounge_access).to eq(false)
  end
end
