class CheckMonthlySpent
  include Modules::RecordFinder

  def initialize
  end

  def call
    @clients = select_all_clients
    return false unless check_monthly_spent
    return true if reset_free_coffee_elegibility
  end

  private

  def select_all_clients
    User.clients.includes(:point)
  end

  def check_monthly_spent
    @clients.each do |client|
      user_rewards = create_or_find_one_record(Reward, client)

      updates_reward_record(user_rewards) if total_points_current_month(client) - total_points_last_month(client) > 100
      update_prior_months_points(client)
    end
  end

  def updates_reward_record(user_rewards)
    user_rewards.free_coffee = true
    user_rewards.save!
  end

  def update_prior_months_points(client)
    user_points = create_or_find_one_record(Point, client)

    user_points.amount_prior_month = total_points_current_month(client)
    user_points.save!
  end

  def total_points_current_month(client)
    client.point&.amount.nil? ? 0 : client.point.amount
  end

  def total_points_last_month(client)
    client.point&.amount_prior_month.nil? ? 0 : client.point.amount_prior_month
  end

  def reset_free_coffee_elegibility
    RewardElegible.all.update_all(free_coffee: true)
  end
end
