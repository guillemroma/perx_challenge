class CheckMonthlySpentJob < ApplicationJob
  queue_as :default

  def perform
    service = CheckMonthlySpent.new
    service.call
  end
end
