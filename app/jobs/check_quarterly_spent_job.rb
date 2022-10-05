class CheckQuarterlySpentJob < ApplicationJob
  queue_as :default

  def perform
    service = CheckQuarterlySpent.new
    service.call
  end
end
