class CheckBirthday
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
      @user_rewards.free_coffee = true if client.birthday == @today
      @user_rewards.save!
    end
  end

  def find_user_rewards(client)
    Reward.find_by(user: client)
  end

  def crate_new_rewards(client)
    Reward.create!(user: client)
  end
end
