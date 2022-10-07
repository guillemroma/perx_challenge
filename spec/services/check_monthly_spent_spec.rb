require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Check Monthly Spent Service', type: :service do
  before(:each) do
    @money = FactoryBot.create(:user_client, email: "test@test.com", birthday: Date.today)
    @cheap = FactoryBot.create(:user_client, email: "test1@test.com", birthday: Date.today - 1)
    10.times do
      Transaction.create!(
        user_id: @money.id,
        country: User::COUNTRIES.sample,
        amount: 1_000_000,
        date: rand(Date.today-20..Date.today)
      )

      UpdateUserPoints.new(@money.id).call
      UpdateUserRewards.new(@money.id).call
    end

    RewardElegible.create(user_id: @cheap.id, free_coffee: false)
  end

  it 'returns true if successfully implemented' do
    service = CheckMonthlySpent.new

    expect(service.call).to eq(true)
  end

  it 'adds a free coffee reward if users monthly points are > 100' do
    service = CheckMonthlySpent.new
    service.call

    expect(Reward.find_by(user_id: @money.id).free_coffee).to eq(true)
  end

  it 'adds does NOT a free coffee reward if users monthly points are > 100' do
    service = CheckMonthlySpent.new
    service.call

    expect(Reward.find_by(user_id: @cheap.id).free_coffee).to eq(false)
  end

  it 'resets free coffee elegibility' do
    service = CheckMonthlySpent.new
    service.call

    expect(RewardElegible.find_by(user_id: @money.id).free_coffee).to eq(true)
  end

  it 'updates elegibility of free coffee' do
    service = CheckMonthlySpent.new
    service.call

    expect(RewardElegible.find_by(user_id: @cheap.id).free_coffee).to eq(true)
  end
end
