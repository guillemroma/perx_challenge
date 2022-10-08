class CreateTransaction
  include ActiveModel::Model

  attr_reader :user, :amount, :date, :country, :transaction

  delegate :errors, to: :transaction

  def initialize(arguments)
    @user = User.find(arguments[:user_id])
    @amount = arguments[:amount]
    @date = arguments[:date]
    @country = arguments[:country]
  end

  def call
    @transaction = Transaction.new(
      user: user,
      amount: amount,
      date: date,
      country: country
    )

    return true if @transaction.save

    false
  end
end
