class CheckBirthdayJob < ApplicationJob
  queue_as :default

  def perform
    # Do something later
    service = CheckBirthday.new
    service.call
  end
end
