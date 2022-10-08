## Overview<br>
The app has been built using the following gems:

(1) **Pundit** for Authorization<br>
(2) **Devise** for Authentication<br>
(3) **Rspec** and **Factory Bot Rails** for Testing<br>
(4) **Whenever** to automate Tasks<br>
(5) **Sidekiq** to manage background Tasks<br>

## Pre-requisites<br>
Run the following commands:<br>

(1) bundle install<br>

(2.1) crontab -r<br>
(2.2) sudo service cron start
(2.3) sudo service cron status -> make sure that it returns 'cron is running'<br>
(2.4) whenever --update-crontab --set environment='development'<br>

(3) sidekiq<br>

(4) rails db:migrate<br>
(5) rails db:seed<br>


Seeds will ccreate an admin (user_type: "corporation") and 6 clients (user_type: "client")

## App's design and architecture<br>

### Authorization
Authorization is based on user_type ("client" or "corporation"). 

* A "client" user_type is only allowed to (1) access her own dashboard, (2) claim her rewards and (3) check her memberhsip.
* A "corporation" user_type can: (1) create new clients and edit existing ones, (2) create new transactions, (3) view client's points and transactions and (4) delete clients

### Models and its use

* **Point**: Keeps track of a given user's aggregated points from the current month and the prior one. Points are refreshed yearly. 
* **Reward**: Keeps track of a given user's rewards. Rewards are refreshed daily, monthly, quarterly, yearly, depending on the reward.  
* **Membership**: Keeps track of a given user's membership type. Memberships are refreshed yearly. 
* **Transaction**: Keeps track of a given user's transactions records.
* **PointRecord**: Keeps track of a given user's points, at the end of every year. Records that belong to different years than the current one and the prior one, are destroyed.
* **TierControl**: Keeps track of the membership type (in the current and in the prior year) of given user. 
* **CreateAirportLoungeControl**: Only exists for those user's who earned the '4x Airport Lounge Access' reward. The model keeps track of the remaining accesses at any given time. Records are removed once there are no more remaining accesses.
* **RewardElegible**: Keeps track of a given user's elegibility for any single reward. Reward Eligible is refreshed monthly, quarterly, yearly or never, depending on the reward.

## Next steps<br>
How can it be improved?

(1) If the app is finally released, multi-tenancy could be explored. The **Apartment** gem could be a great approach<br>
(2) Add **AuditLogs** to the most relevant transactions<br>
(3) Add **begin** and **resque** where applicable<br>
