class DestroyUser
  include ActiveModel::Model

  attr_reader :user

  delegate :errors, to: :user

  def initialize(arguments)
    @user = User.find(arguments)
  end

  def call
    return false unless user.destroy

    true
  end
end
