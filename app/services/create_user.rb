class CreateUser
  include ActiveModel::Model
  include Modules::RecordFinder

  attr_reader :user, :email, :password, :user_type, :birthday, :country

  delegate :errors, to: :user

  def initialize(arguments)
    @email = arguments[:email]
    @password = arguments[:password]
    @user_type = arguments[:user_type]
    @birthday = arguments[:birthday]
    @country = arguments[:country]
  end

  def call
    @user = User.new(
      email: @email,
      password: @password,
      user_type: @user_type,
      birthday: @birthday,
      country: @country
    )

    return false unless @user.save

    create_or_find_one_record(TierControl, @user)

    true
  end
end
