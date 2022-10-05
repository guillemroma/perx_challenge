class YearlyRefreshJob < ApplicationJob
  queue_as :default

  def perform
    service = YearlyRefresh.new
    service.call
  end
end
