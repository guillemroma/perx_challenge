class UpdateUser
  include ActiveModel::Model

  attr_reader :email, :birthday, :country
  attr_accessor :user

  delegate :errors, to: :user

  def initialize(arguments)
    @user = User.find(arguments[:id].to_i)
    @email = arguments[:email]
    @birthday = arguments[:birthday]
    @country = arguments[:country]
  end

  def call
    return false unless update_user

    true
  end

  private

  def update_user
    @user.update(
      email: @email,
      birthday: @birthday,
      country: @country
    )
  end
end
