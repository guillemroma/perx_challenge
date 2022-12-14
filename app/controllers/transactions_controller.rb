class TransactionsController < ApplicationController
  include Modules::Messages
  before_action :check_authorization
  after_action :update_user_rewards, only: [:create]
  after_action :update_user_points, only: [:create]

  def index
    user = User.find(params["user_id"])
    @transactions = Transaction.where(user_id: user.id).includes(:user)
  end

  def new
    @user = User.find(params[:user_id])
    @transaction = Transaction.new
  end

  def create
    service = CreateTransaction.new(transaction_create_params)

    if service.call
      success_flash_message(:alert, "Transaction was successfully created")
      redirect_to(users_path)
    else
      error_flash_message(:alert, service.errors)
      redirect_to(new_user_transaction_path(params["user_id"]))
    end
  end

  private

  def transaction_create_params
    create_params = params.require(:transaction).permit(:amount, :date, :country)
    create_params.merge(user_id: params["user_id"])
  end

  def update_user_points
    UpdateUserPointsJob.perform_later(update_user_points_and_rewards_params)
  end

  def update_user_rewards
    UpdateUserRewardsJob.perform_later(update_user_points_and_rewards_params)
  end

  def update_user_points_and_rewards_params
    params["user_id"]
  end

  def check_authorization
    authorize Transaction
  end
end
