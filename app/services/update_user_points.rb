class UpdateUserPoints
  attr_reader :user

  def initialize(arguments)
    @user = User.find(arguments)
  end

  def call
    update_or_create_user_points
  end

  private

  def update_or_create_user_points
    @user_transactions = get_user_transactions
    update_or_create_points
  end

  def get_user_transactions
    Transaction.where(user: @user)
  end

  def local_transactions
    local_transaction = @user_transactions.where(country: @user.country)
    local_transaction.sum { |transaction| transaction.amount }
  end

  def foreign_transactions
    foreign_transactions = @user_transactions.where.not(country: @user.country)
    foreign_transactions.sum { |transaction| transaction.amount }
  end

  def update_or_create_points
    @user_points = find_points ? find_points : Point.new(user: @user)
    @user_points.amount = local_transactions / 100 * standard_points + foreign_transactions / 100 * standard_points(2)
    @user_points.save!
  end

  def find_points
    Point.find_by(user: @user)
  end

  def standard_points(multiplier = 1)
    10 * multiplier
  end
end