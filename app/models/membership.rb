class Membership < ApplicationRecord
  belongs_to :user

  MEMBERHSIP_TYPES = [:standard, :gold, :platinium]
end
