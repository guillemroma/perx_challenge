class CheckBirthday
  include Modules::RecordFinder

  def initialize
  end

  def call
    @today = Date.today
    @clients = select_all_clients
    true if check_birthday
  end

  private

  def select_all_clients
    User.clients
  end

  def check_birthday
    @clients.each do |client|
      user_rewards = create_or_find_one_record(Reward, client)
      updates_reward_record(user_rewards) if client.birthday == @today
    end
  end

  def updates_reward_record(user_rewards)
    user_rewards.free_coffee = true
    user_rewards.save!
  end
end
