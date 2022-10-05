class UpdateUserRewardsJob < ApplicationJob
  queue_as :default

  def perform(update_user_points_and_rewards_params)
    service = UpdateUserRewards.new(update_user_points_and_rewards_params)
    service.call
  end
end
