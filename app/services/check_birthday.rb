class CheckBirthday
  include Modules::FindRewards

  def initialize
  end

  def call
    @today = Date.today
    @clients = select_all_clients
    check_birthday
  end

  private

  def select_all_clients
    User.clients
  end

  def check_birthday
    @clients.each do |client|
      if find_user_rewards(client)
        @user_rewards = find_user_rewards(client)
      else
        @user_rewards = crate_new_rewards(client)
      end

      updates_reward_record if client.birthday == @today
    end
  end

  def updates_reward_record
    @user_rewards.free_coffee = true
    @user_rewards.save!
  end
end
