class UpdateUserRewards
  attr_reader :user

  def initialize(arguments)
    @user = User.find(arguments)
  end

  def call
    update_user_rewards
  end

  private

  def update_user_rewards
    @user_points = obtain_user_points
    update_rewards
  end

  def obtain_user_points
    Point.find_by(user: @user)
  end

  def update_rewards
    # run check spent 60 days
    # run check top 10 transactions
    # CheckBirthdayJob.perform_later
  end
end
