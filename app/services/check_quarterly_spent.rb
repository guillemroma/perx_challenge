class CheckQuarterlySpent
  include Modules::RecordFinder

  def initialize
  end

  def call
    @clients = select_all_clients
    return true if check_quarterly_spent

    false
  end

  private

  def select_all_clients
    User.clients.includes(:transactions)
  end

  def check_quarterly_spent
    @clients.each do |client|
      create_or_find_one_record(Reward, client)

      increase_user_points(client) if total_spent_current_quarter(client) > 2_000
    end
  end

  def total_spent_current_quarter(client)
    quarterly_transactions = client.transactions.where(date: [(prior_quarter..Date.today)])
    quarterly_transactions.sum(:amount)
  end

  def increase_user_points(client)
    user_points = create_or_find_one_record(Point, client)

    user_points.amount += 100
    user_points.save!
  end

  def prior_quarter
    case Date.today.month
    when 3
      DateTime.new(Date.today.year, 1, 1)
    when 6
      DateTime.new(Date.today.year, 3, 1)
    when 9
      DateTime.new(Date.today.year, 6, 1)
    when 12
      DateTime.new(Date.today.year, 9, 1)
    else
      Date.today
    end
  end
end
