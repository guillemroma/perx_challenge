require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Create Transaction Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = CreateTransaction.new(
      user_id: @client.id,
      date: Date.today,
      amount: 100,
      country: "Spain"
    )

    expect(service.call).to eq(true)
  end

  it 'returns false if UNsuccessfully implemented' do
    service = CreateTransaction.new(
      user_id: @client.id,
      date: Date.today,
      country: "Spain"
    )

    expect(service.call).to eq(false)
  end

  it 'creates a new transaction' do
    service = CreateTransaction.new(
      user_id: @client.id,
      date: Date.today,
      amount: 100,
      country: "Spain"
    )
    service.call

    expect(Transaction.count).to eq(1)
  end

  it 'adds errors to service if UNsuccessfully implemented' do
    service = CreateTransaction.new(
      user_id: @client.id,
      date: Date.today,
      country: "Spain"
    )

    service.call

    expect(service.errors.first.type).to eq(:blank)
  end
end
