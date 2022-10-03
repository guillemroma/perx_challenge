class Reward < ApplicationRecord
  belongs_to :user

  validates :free_coffee, presence: true
  validates :cash_rebate, presence: true
  validates :free_movie_tickets, presence: true
  validates :airport_lounge_access, presence: true

end
