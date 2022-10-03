class PointRecord < ApplicationRecord
  belongs_to :user

  validates :year, presence: true
  validates :amount, presence: true
end
