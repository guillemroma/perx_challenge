require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Update user Points Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = UpdateUserPoints.new(@client.id)

    expect(service.call).to eq(true)
  end

  it 'Adds 10 points if a 100 $ transaction is from the same country as the user' do
    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 100,
      date: Date.today
    )

    service = UpdateUserPoints.new(@client.id)
    service.call

    expect(Point.find_by(user_id: @client.id).amount).to eq(10)
  end

  it 'Adds 0 points if a 99 $ transaction is added' do
    Transaction.create!(
      user_id: @client.id,
      country: @client.country,
      amount: 99,
      date: Date.today
    )

    service = UpdateUserPoints.new(@client.id)
    service.call

    expect(Point.find_by(user_id: @client.id).amount).to eq(0)
  end

  it 'Adds 20 points if a 100 $ transaction is from a different country than the user' do
    Transaction.create!(
      user_id: @client.id,
      country: "France",
      amount: 100,
      date: Date.today
    )

    service = UpdateUserPoints.new(@client.id)
    service.call

    expect(Point.find_by(user_id: @client.id).amount).to eq(20)
  end

  it 'Adds 300 points if a 10 x 100 $ transaction in user country and 10 x 100$ transaction in another country' do
    10.times do
      Transaction.create!(
        user_id: @client.id,
        country: "France",
        amount: 100,
        date: Date.today
      )
    end

    10.times do
      Transaction.create!(
        user_id: @client.id,
        country: @client.country,
        amount: 100,
        date: Date.today
      )
    end

    service = UpdateUserPoints.new(@client.id)
    service.call

    expect(Point.find_by(user_id: @client.id).amount).to eq(300)
  end
end
