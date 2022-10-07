class CreateRewardRecord
  include ActiveModel::Model
  include Modules::RecordFinder

  attr_reader :user

  delegate :errors, to: Reward

  def initialize(email)
    @user = User.find_by(email: email)
  end

  def call
    return false unless create_or_find_one_record(Reward, @user)

    true
  end
end
