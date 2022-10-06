class SpendRewards
  include Modules::RecordFinder

  attr_reader :user, :user_rewards

  delegate :errors, to: :user_rewards

  def initialize(user_id:, reward_type:)
    @user = User.find(user_id)
    @reward_type = reward_type
  end

  def call
    update_user_rewards
  end

  private

  def update_user_rewards
    @user_rewards = create_or_find_one_record(Reward, @user)
    spend_rewards
  end

  def spend_rewards
    case @reward_type
    when "free_coffee"
      if @user_rewards.free_coffee
        @user_rewards.free_coffee = false
        @user_rewards.save!
      end
    when "cash_rebate"
      if @user_rewards.cash_rebate
        @user_rewards.cash_rebate = false
        @user_rewards.save!
      end
    when "free_movie_tickets"
      if @user_rewards.free_movie_tickets
        @user_rewards.free_movie_tickets = false
        @user_rewards.save!
      end
    when "airport_lounge_access"
      update_airport_lounge_accesses if @user_rewards.airport_lounge_access
    end
  end

  def update_airport_lounge_accesses
    @airport_lounge_control = AirportLoungeControl.find_by(user_id: @user.id)
    @airport_lounge_control.remaining -= 1
    if @airport_lounge_control.remaining.zero?
      @user_rewards.airport_lounge_access = false
      @user_rewards.save!
      @airport_lounge_control.destroy!
    else
      @airport_lounge_control.save
    end
  end
end
