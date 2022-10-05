class CheckMonthlySpent
  def initialize
  end

  def call
    @current_month = Date.today.month
    @clients = select_all_clients
    check_monthly_spent
  end

  private

  def select_all_clients
    User.clients.includes(:points)
  end

  def check_monthly_spent
    @clients.each do |client|
      if find_user_rewards(client)
        @user_rewards = find_user_rewards(client)
      else
        @user_rewards = crate_new_rewards(client)
      end

      updates_reward_record if client.point == @today
    end
  end

  def updates_reward_record
    @user_rewards.free_coffee = true
    @user_rewards.save!
  end
end
