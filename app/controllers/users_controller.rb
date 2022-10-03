class UsersController < ApplicationController
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
      redirect_to(users_path)
    else
      flash[:alert] = service.errors
      redirect_to(new_user_path)
    end
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
    params.require(:user).permit(:email, :country, :birthday, :user_type, :password)
  end
end
