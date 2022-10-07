require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Create Reward Record Service', type: :service do
  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'returns true if successfully implemented' do
    service = CreateRewardRecord.new(@client.email)

    expect(service.call).to eq(true)
  end

  it 'creates a new reward' do
    service = CreateRewardRecord.new(@client.email)
    service.call

    expect(Reward.count).to eq(1)
  end
end
