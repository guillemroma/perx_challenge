module Dashboard
  class UserPolicy < ApplicationPolicy
    def show?
      user.user_type == "client"
    end

    def update?
      user.user_type == "client"
    end
  end
end
