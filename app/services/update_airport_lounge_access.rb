class UpdateAirportLoungeAccess
  include Modules::RecordFinder

  attr_reader :user
  attr_accessor :user_rewards

  delegate :errors, to: :airport_lounge_control

  def initialize(user_id, user_rewards)
    @user = User.find(user_id)
    @user_rewards = user_rewards
  end

  def call
    return true if update_airport_lounge_accesses

    false
  end

  private

  def update_airport_lounge_accesses
    airport_lounge_control = create_or_find_one_record(AirportLoungeControl, @user)
    airport_lounge_control.remaining -= 1

    if airport_lounge_control.remaining.zero?
      user_rewards.airport_lounge_access = false
      user_rewards.save!
      airport_lounge_control.destroy!
    else
      airport_lounge_control.save
    end
  end
end
