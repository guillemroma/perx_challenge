class CheckMonthlySpent
  include Modules::FindRewards

  def initialize
  end

  def call
    @clients = select_all_clients
    check_monthly_spent
    reset_free_coffee_elegibility
  end

  private

  def select_all_clients
    User.clients.includes(:point)
  end

  def check_monthly_spent
    @clients.each do |client|
      if find_user_rewards(client)
        @user_rewards = find_user_rewards(client)
      else
        @user_rewards = crate_new_rewards(client)
      end

      updates_reward_record if total_points_current_month(client) - total_points_last_month(client) > 100
      update_prior_months_points(client)
    end
  end

  def updates_reward_record
    @user_rewards.free_coffee = true
    @user_rewards.save!
  end

  def update_prior_months_points(client)
    if find_points(client)
      @user_points = find_points(client)
    else
      @user_points = Point.new(user: client, amount: 0)
    end

    @user_points.amount_prior_month = total_points_current_month(client)
    @user_points.save!
  end

  def find_points(client)
    Point.find_by(user: client)
  end

  def total_points_current_month(client)
    client.point&.amount.nil? ? 0 : client.point.amount
  end

  def total_points_last_month(client)
    client.point&.amount_prior_month.nil? ? 0 : client.point.amount_prior_month
  end

  def reset_free_coffee_elegibility
    PointRecord.where.not(year: [@current_year, @current_year - 1]).destroy_all
    RewardElegible.all.update_all(free_coffee: true)
  end
end
