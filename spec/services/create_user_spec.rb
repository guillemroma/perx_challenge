require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Create User Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = CreateUser.new(
      email: "test@test.com",
      password: 123456,
      user_type: "client",
      birthday: Date.today,
      country: "Spain"
    )

    expect(service.call).to eq(true)
  end

  it 'returns false if UNsuccessfully implemented' do
    service = CreateUser.new(
      email: @client.email,
      password: 123456,
      user_type: "client",
      birthday: Date.today,
      country: "Spain"
    )

    expect(service.call).to eq(false)
  end

  it 'creates a new User' do
    service = CreateUser.new(
      email: "test@test.com",
      password: 123456,
      user_type: "client",
      birthday: Date.today,
      country: "Spain"
    )
    
    service.call

    expect(User.count).to eq(2)
  end

  it 'adds errors to service if UNsuccessfully implemented' do
    service = CreateUser.new(
      email: @client.email,
      password: 123456,
      user_type: "client",
      birthday: Date.today,
      country: "Spain"
    )

    service.call

    expect(service.errors.first.type).to eq(:taken)
  end
end
