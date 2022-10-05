# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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

User.all.each do |user|
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
puts "#{Point.count} Points records created"
puts "#{Reward.count} Rewards updated"
