env :PATH, ENV['PATH']
set :output, './log/cron.log'

every '0 0 1 1 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # points expiere + add points record record
  # calculate loyalty tier
  # add airport lounge reward if user becomes gold tier
end

every '0 0 31 3,6,9,12 *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # bonus points if spent is greater than 2k
end

every '0 0 1 * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # check if user has 100 points an give free cofee reward
end

every '0 0 * * *' do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  # check if it is users birthday and give free cofee reward
  runner 'Reward.check_birthday'
  # checks if spending is > 1000 in the first 60 days since 1st transaction and gives movie tickets
end
