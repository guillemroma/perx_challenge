class CheckQuarterlySpent
  include Modules::FindRewards

  def initialize
  end

  def call
    @clients = select_all_clients
    check_quarterly_spent
  end

  private

  def select_all_clients
    User.clients.includes(:transactions)
  end

  def check_quarterly_spent
    @clients.each do |client|
      if find_user_rewards(client)
        @user_rewards = find_user_rewards(client)
      else
        @user_rewards = crate_new_rewards(client)
      end
      increase_user_points(client) if total_points_current_quarter(client) > 2_000
    end
  end

  def total_points_current_quarter(client)
    quarterly_transactions = client.transactions.where(date: [(prior_quarter..Date.today)])
    quarterly_transactions.sum(:amount)
  end

  def increase_user_points(client)
    if find_points(client)
      @user_points = find_points(client)
    else
      @user_points = Point.new(user: client, amount: 0)
    end

    @user_points.amount += 100
    @user_points.save!
  end

  def find_points(client)
    Point.find_by(user: client)
  end

  def prior_quarter
    case reset_client_points_records(client)
    when 3
      DateTime.new(Date.today.year, 1, 1)
    when 6
      DateTime.new(Date.today.year, 3, 1)
    when 9
      DateTime.new(Date.today.year, 6, 1)
    when 12
      DateTime.new(Date.today.year, 9, 1)
    end
  end
end
