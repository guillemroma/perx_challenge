module Dashboard
  class UserPolicy < ApplicationPolicy
    def show?
      user.user_type == "client"
    end
  end
end
