module Dashboard
  class UsersController < ApplicationController
    def show
      authorize([:dashboard, User])
    end
  end
end
