require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Update user Service', type: :service do
  before(:each) do
    @corporation = FactoryBot.create(:user_corporation)
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = UpdateUser.new(
      {
        id: @client.id,
        email: @client.email,
        birthday: @client.birthday - 1,
        country: @client.country
      }
    )

    expect(service.call).to eq(true)
  end

  it 'returns false if UNsuccessfully implemented' do
    service = UpdateUser.new(
      {
        id: @client.id,
        email: "son@goku.com",
        birthday: @client.birthday - 1,
        country: @client.country
      }
    )
    expect(service.call).to eq(false)
  end

  it 'adds errors to service if UNsuccessfully implemented' do
    service = UpdateUser.new(
      {
        id: @client.id,
        email: "son@goku.com",
        birthday: @client.birthday - 1,
        country: @client.country
      }
    )

    service.call

    expect(service.errors.first.type).to eq(:taken)
  end

  it 'updates User record' do
    service = UpdateUser.new(
      {
        id: @client.id,
        email: "kakashi@sensei.com",
        birthday: @client.birthday - 1,
        country: @client.country
      }
    )

    service.call

    expect(User.find(@client.id).email).to eq("kakashi@sensei.com")
  end
end
