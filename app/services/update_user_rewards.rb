class UpdateUserRewards
  include Modules::RecordFinder

  attr_reader :user
  attr_accessor :user_rewards, :user_reward_elegibility, :user_transactions

  def initialize(arguments)
    @user = User.find(arguments)
    @user_rewards = create_or_find_one_record(Reward, @user)
    @user_reward_elegibility = create_or_find_one_record(RewardElegible, @user)
    @user_transactions = create_or_find_many_records(Transaction, @user)
  end

  def call
    return true if update_user_rewards

    false
  end

  private

  def update_user_rewards
    update_rewards
    update_elegibility
  end

  def update_rewards
    if check_user_spent_first_60_days(user_transactions, user_reward_elegibility) > 1_000
      update_free_movie_tickets_reward
    end

    return unless check_user_top_10_transactions(user_transactions, user_reward_elegibility) >= 10

    update_cash_rebate_reward
  end

  def check_user_spent_first_60_days(transactions, user_reward_elegibility)
    return 0 if user_reward_elegibility.free_movie_tickets == false

    ordered_transactions = transactions.order(date: :asc)
    return 0 unless ordered_transactions.first.date > Date.today - 60

    ordered_transactions.sum(:amount)
  end

  def check_user_top_10_transactions(transactions, user_reward_elegibility)
    return 0 if user_reward_elegibility.cash_rebate == false

    transactions_greater_than100 = transactions.where("amount > ?", 100).limit(10)
    transactions_greater_than100.count
  end

  def update_free_movie_tickets_reward
    user_rewards.free_movie_tickets = true
    user_rewards.save!
  end

  def update_cash_rebate_reward
    user_rewards.cash_rebate = true
    user_rewards.save!
  end

  def update_elegibility
    user_reward_elegibility.free_movie_tickets = false if user_rewards.free_movie_tickets
    user_reward_elegibility.cash_rebate = false if user_rewards.cash_rebate

    user_reward_elegibility.save!
  end
end
