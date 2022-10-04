class CheckSpentFirst60DaysJob < ApplicationJob
  queue_as :default

  def perform(client)
    # Do something later
    service = CheckSpentFirst60Days.new(client)
    service.call
  end
end
