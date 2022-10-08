class CreateRewardRecord
  include ActiveModel::Model
  include Modules::RecordFinder

  attr_reader :user

  delegate :errors, to: Reward

  def initialize(email)
    @user = User.find_by(email: email)
  end

  def call
    return true if create_or_find_one_record(Reward, @user)

    false
  end
end
