class UpdateUserPointsJob < ApplicationJob
  queue_as :default

  def perform(update_user_points_and_points_params)
    service = UpdateUserPoints.new(update_user_points_and_points_params)
    service.call
  end
end
