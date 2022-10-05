class RefreshPointsJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    service = RefreshPoints.new
    service.call
  end


  # update membership!!!

end
