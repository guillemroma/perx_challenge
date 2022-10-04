class CheckMonthlySpentJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    service = CheckMonthlySpent.new
    service.call
  end
end
