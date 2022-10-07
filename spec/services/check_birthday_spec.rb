require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Check Birthday Service', type: :service do
  before(:each) do
    @birthday = FactoryBot.create(:user_client, email: "test@test.com", birthday: Date.today)
    @no_birthday = FactoryBot.create(:user_client, email: "test1@test.com", birthday: Date.today - 1)
  end

  it 'returns true if successfully implemented' do
    service = CheckBirthday.new

    expect(service.call).to eq(true)
  end
  
  it 'adds a free coffee reward to each user who\'s bday is "today"' do
    service = CheckBirthday.new
    service.call

    expect(Reward.find_by(user_id: @birthday.id).free_coffee).to eq(true)
  end

  it 'does not add a free coffee to users who\'s bday is NOT "today"' do
    service = CheckBirthday.new
    service.call

    expect(Reward.find_by(user_id: @no_birthday.id).free_coffee).to eq(false)
  end
end
