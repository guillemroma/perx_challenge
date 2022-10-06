User.destroy_all
puts "DB cleaned!"

puts "Creating Admin..."
n = 0

User.create(
  email: "dummy@gmail.com",
  password: 123456,
  user_type: "corporation",
  birthday: Faker::Date.birthday,
  country: User::COUNTRIES.sample
)
n += 1

puts "#{User.where(user_type: "corporation").count} Admins created"

puts "Creating Clients..."

User.create!(
  email: "aa@aa.com",
  password: 123456,
  user_type: "client",
  birthday: Faker::Date.birthday,
  country: User::COUNTRIES.sample
)
n += 1


5.times do
  User.create!(
    email: "user_#{n}@gmail.com",
    password: 123456,
    user_type: "client",
    birthday: Faker::Date.birthday,
    country: User::COUNTRIES.sample
  )
  n += 1
end

puts "#{User.where(user_type: "client").count} Clients created"

puts "Creating Transactions, Points and Rewards..."

def create_or_find_one_record(model, client)
  if record_created?(model, client)
    model.find_by(user_id: client.id)
  else
    model.create!(user_id: client.id)
  end
end

def record_created?(model, client)
  model.find_by(user_id: client.id)
end

User.all.each do |user|
  next if user.email == "dummy@gmail.com"

  create_or_find_one_record(TierControl, user)

  if user.email == "aa@aa.com"
    UpdateUserPoints.new(user.id).call
    UpdateUserRewards.new(user.id).call
    next
  end

  10.times do
    Transaction.create!(
      user_id: user.id,
      country: User::COUNTRIES.sample,
      amount: rand(1..100_000),
      date: rand(Date.today-20..Date.today)
    )

    UpdateUserPoints.new(user.id).call
    UpdateUserRewards.new(user.id).call
  end
end

puts "#{Transaction.count} Transactions created"
puts "#{Point.count} Points created"
puts "#{Reward.count} Rewards updated"
