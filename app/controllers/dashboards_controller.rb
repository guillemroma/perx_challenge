class DashboardsController < ApplicationController
  def new
    @user = current_user
    redirect_to(dashboards_user_path(@user))
  end

  def show

  end
end
