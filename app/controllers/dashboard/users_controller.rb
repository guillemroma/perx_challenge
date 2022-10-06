module Dashboard
  class UsersController < ApplicationController
    def show
      authorize([:dashboard, User])
      @client = User.find(params[:id])
      @rewards = Reward.find_by(user_id: params[:id])
      @airport_lounge_control = AirportLoungeControl.find_by(user_id: params[:id])
      @membership = Membership.find_by(user_id: params[:id])
    end

    def update
      service = SpendRewards.new(user_id: params[:id], reward_type: params[:reward])

      if service.call
        flash[:alert] = "Reward Spent"
      else
        flash[:alert] = service.errors
      end

      redirect_to(dashboard_user_path(params[:id]))
    end
  end
end
