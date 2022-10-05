class CheckBirthdayJob < ApplicationJob
  queue_as :default

  def perform
    service = CheckBirthday.new
    service.call
  end
end
