The app has been built using the following gems:

(1) Pundit for Authorization
(2) Devise for Authentication
(3) Rspec and Factory Bot Rails for Testing
(4) Whenever to automate Tasks
(5) Sidekiq to manage background Tasks

Before launching the server, run the following commands:

(1) bundle install

(2.1) crontab -r
(2.2) sudo service cron start
(2.3) sudo service cron status -> make sure that it returns 'cron is running'
(2.4) whenever --update-crontab --set environment='development'

(3) sijdekiq

(4) rails db:migrate
(5) rails db:seed


The seeds will provide an admin (user_type: "corporation") and 6 clients (user_type: "client")

schema


How can it be improved?

(1) If the app is realsed, multi-tenancy could be explored. The 'Apartment' gem could be a great approach
(2) Add AuditLogs to the most relevant transactions
(3) Add begins and resques where applicable
