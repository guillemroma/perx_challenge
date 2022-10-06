class TransactionPolicy < ApplicationPolicy
  def index?
    user.user_type == "corporation"
  end

  def new?
    user.user_type == "corporation"
  end

  def create?
    user.user_type == "corporation"
  end
end
