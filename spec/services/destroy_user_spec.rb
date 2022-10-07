require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Destroy User Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = DestroyUser.new(@client.id)
    service.call

    expect(service.call).to eq(true)
  end

  it 'deletes user record' do
    service = DestroyUser.new(@client.id)
    service.call

    expect(Reward.count).to eq(0)
  end
end
