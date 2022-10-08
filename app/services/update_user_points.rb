class UpdateUserPoints
  include Modules::RecordFinder

  attr_reader :user
  attr_accessor :user_transactions

  def initialize(arguments)
    @user = User.find(arguments)
    @user_transactions = create_or_find_many_records(Transaction, @user)
  end

  def call
    return true if update_or_create_user_points

    false
  end

  private

  def update_or_create_user_points
    user_points = create_or_find_one_record(Point, @user)
    user_points.amount = ((local_transactions / 100).floor * standard_points) + ((foreign_transactions / 100).floor * standard_points(2))
    user_points.save!
  end

  def local_transactions
    local_transaction = user_transactions.where(country: @user.country)
    local_transaction.sum(&:amount)
  end

  def foreign_transactions
    foreign_transactions = user_transactions.where.not(country: @user.country)
    foreign_transactions.sum(&:amount)
  end

  def standard_points(multiplier = 1)
    10 * multiplier
  end
end
