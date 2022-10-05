class CheckQuarterlyJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    service = CheckQuarterly.new
    service.call
  end
end
