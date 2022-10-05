env :PATH, ENV['PATH']
set :output, './log/cron.log'

every '50 23 31 12 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # points expiere + add points record record
  # calculate loyalty tier
  # add airport lounge reward if user becomes gold tier
end

every '50 23 31 3,6,9,12 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # bonus points if spent is greater than 2k
  runner 'CheckQuarterlySpentJob.perform_now'
end

every '0 0 1 * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # check if user has 100 points an give free cofee reward
  runner 'CheckMonthlySpentJob.perform_now'
end

every '0 0 * * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # check if it is users birthday and give free cofee reward
  runner 'CheckBirthdayJob.perform_now'
  # checks if spending is > 1000 in the first 60 days since 1st transaction and gives movie tickets
end

# REMOVE ONCE WORKING

every 1.minute do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # check if it is users birthday and give free cofee reward
  runner 'CheckBirthdayJob.perform_now'
  # checks if spending is > 1000 in the first 60 days since 1st transaction and gives movie tickets
end
