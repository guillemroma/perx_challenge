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
    @user_points = get_user_points
    update_rewards
  end

  def get_user_points
    Point.find_by(user: @user)
  end

  def update_rewards

  end
end
