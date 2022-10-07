env :GEM_PATH, ENV['GEM_PATH']
set :output, './log/cron.log'
set :environment, "development"

every '50 23 31 12 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner 'YearlyRefreshJob.perform_now'
end

every '50 23 31 3,6,9,12 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner 'CheckQuarterlySpentJob.perform_now'
end

every '0 0 1 * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner 'CheckMonthlySpentJob.perform_now'
end

every '0 0 * * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner 'CheckBirthdayJob.perform_now'
end

# REMOVE ONCE WORKING

every 1.minute do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner 'YearlyRefreshJob.perform_now'
  runner 'CheckQuarterlySpentJob.perform_now'
  runner 'CheckMonthlySpentJob.perform_now'
  runner 'CheckBirthdayJob.perform_now'
end
