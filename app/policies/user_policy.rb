class UserPolicy < ApplicationPolicy
  def index?
    user.user_type == "corporation"
  end

  def show?
    user.user_type == "corporation"
  end

  def new?
    user.user_type == "corporation"
  end

  def edit?
    user.user_type == "corporation"
  end

  def update?
    user.user_type == "corporation"
  end

  def create?
    user.user_type == "corporation"
  end

  def destroy?
    user.user_type == "corporation"
  end
end
