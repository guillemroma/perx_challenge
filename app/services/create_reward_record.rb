class CreateRewardRecord
  include ActiveModel::Model

  attr_reader :user, :reward

  delegate :errors, to: :reward

  def initialize(email)
    @user = User.find_by(email: email)
  end

  def call
    @reward = Reward.new(user: @user)

    return false unless @reward.save

    true
  end
end
