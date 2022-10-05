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
    @user_rewards = user_rewards
    update_rewards
  end

  def user_rewards
    if find_reward
      Reward.find_by(user: @user)
    else
      Reward.create!(user: @user)
    end
  end

  def find_reward
    Reward.find_by(user: @user)
  end

  def update_rewards
    @user_transactions = user_transactions
    update_free_movie_tickets_reward if check_user_spent_first_60_days(@user_transactions)
    update_cash_rebate_reward if check_user_top_10_transactions(@user_transactions)
  end

  def user_transactions
    Transaction.where(user: @user)
  end

  def check_user_spent_first_60_days(transactions)
    ordered_transactions = transactions.order(date: :asc)

    return false unless ordered_transactions.first.date > Date.today - 60

    ordered_transactions.sum(:amount) > 1_000
  end

  def check_user_top_10_transactions(transactions)
    transactions_greater_than100 = transactions.where("amount > ?", 100).limit(10)

    transactions_greater_than100.count >= 10
  end

  def update_free_movie_tickets_reward
    @user_rewards.free_movie_tickets = true
    @user_rewards.save!
  end

  def update_cash_rebate_reward
    @user_rewards.cash_rebate = true
    @user_rewards.save!
  end
end
