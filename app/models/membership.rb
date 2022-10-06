class Membership < ApplicationRecord
  belongs_to :user

  MEMBERSHIP_TYPES = [:standard, :gold, :platinium]
end
