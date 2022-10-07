class UsersController < ApplicationController
  include Modules::Messages
  include Modules::RecordFinder

  before_action :check_authorization
  after_action :create_reward_record, only: [:create]
  after_action :create_tier_control_and_reward_elegibiity, only: [:create]

  def index
    @clients = User.clients.includes(:point)
  end

  def show
    @client = User.find(user: params[:id])
  end

  def new
    @client = User.new
  end

  def edit
    @client = User.find(params[:id])
  end

  def update
    service = UpdateUser.new(user_create_and_update_params.merge(id: params[:id]))

    if service.call
      success_flash_message(:alert, "User was successfully updated")
      redirect_to(users_path)
    else
      error_flash_message(:alert, service.errors)
      redirect_to(edit_user_path(params[:id]))
    end
  end

  def create
    service = CreateUser.new(user_create_and_update_params)

    if service.call
      success_flash_message(:alert, "User was successfully created")
      redirect_to(users_path)
    else
      error_flash_message(:alert, service.errors)
      redirect_to(new_user_path)
    end
  end

  def destroy
    service = DestroyUser.new(params[:id])

    if service.call
      success_flash_message(:alert, "User was successfully deleted")
    else
      error_flash_message(:alert, service.errors)
    end
    redirect_to(users_path)
  end

  private

  def check_authorization
    authorize User
  end

  def user_create_and_update_params
    params.require(:user).permit(:email, :country, :birthday, :user_type, :password)
  end

  def create_reward_record
    service = CreateRewardRecord.new(params["user"]["email"])

    if service.call
      success_flash_message(:alert, "Reward record was successfully created")
    else
      error_flash_message(:alert, service.errors)
    end
  end

  def create_tier_control_and_reward_elegibiity
    create_or_find_one_record(TierControl, User.last)
    create_or_find_one_record(RewardElegible, User.last)
  end
end
