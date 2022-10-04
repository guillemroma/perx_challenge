class DashboardsController < ApplicationController
  def new
    @user = current_user
    redirect_to(dashboard_user_path(@user))
  end
end
