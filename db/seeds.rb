# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
puts "DB cleaned!"

puts "Creating Admins"
n = 1
1.times do
  User.create!(
    email: "user_#{n}@gmail.com",
    password: 123456,
    user_type: 0,
    birthday: Faker::Date.birthday,
    country: User::COUNTRIES.sample
  )
  n += 1
end

puts "#{User.where(user_type: 0).count} Admins created"

puts "Creating Users"

5.times do
  User.create!(
    email: "user_#{n}@gmail.com",
    password: 123456,
    user_type: 1,
    birthday: Faker::Date.birthday,
    country: User::COUNTRIES.sample
  )
  n += 1
end

puts "#{User.where(user_type: 1).count} Admins created"

puts "Creating transactions"

User.where(user_type: 1).each do |user|
  10.times do
    Transaction.create!(user: user, country: User::COUNTRIES.sample, amount: rand(1..1_000), date: Time.now - rand(1..100))
  end
end

puts "#{Transaction.count} transactions were created"
