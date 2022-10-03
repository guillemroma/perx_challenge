class UsersController < ApplicationController
  def index
    @clients = User.clients.includes(:points)
  end

  def show
    @user = User.find(user: params[:id])
  end

  def new
    @user = User.new
  end

  def update
  end


  def create
    service = CreateUser.new(user_create_and_update_params)

    if service.call
      redirect_to(users_path)
    else
      flash[:alert] = service.errors
      redirect_to(new_user_path)
    end
  end

  def destroy
    service = DestroyUser.new(params[:id])

    flash[:alert] = service.errors unless service.call

    redirect_to(users_path)
  end

  private

  def user_create_and_update_params
    user_params = params.require(:user).permit(:email, :country, :birthday, :user_type, :password)
    user_params[:user_type] = user_params[:user_type].to_i
    user_params
  end
end
