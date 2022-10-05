module Modules
  module FindRewards
    def find_user_rewards(client)
      Reward.find_by(user: client)
    end

    def crate_new_rewards(client)
      CreateRewardRecord.new(client.email).call
    end
  end
end
