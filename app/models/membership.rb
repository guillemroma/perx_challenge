class Membership < ApplicationRecord
  belongs_to :user

  validate :only_one_membership

  validates :standard, presence: true
  validates :gold, presence: true
  validates :platinium, presence: true

  def only_one_membership
    if self.standard
      errors.add(:base, 'Any given User can only belong to one membership plan') unless self.gold || self.platinium
    elsif self.gold
      errors.add(:base, 'Any given User can only belong to one membership plan') unless self.standard || self.platinium
    elsif self.platinium
      errors.add(:base, 'Any given User can only belong to one membership plan') unless self.gold || self.standard
    end
  end
end
