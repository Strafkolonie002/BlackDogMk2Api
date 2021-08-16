class UsersController < ApplicationController
  wrap_parameters :user, include: [:user_code, :user_name, :password, :password_confirmation]

  def index
    users = User.order(created_at: :desc)
    render json: {
      message: "success",
      data: users
    }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'success', data: [user] }
    else
      render json: { message: 'failure', errors: user.errors }
    end
  end

  def show
    @user = set_user
    render json: { message: 'success', data: [@user] }
  end

  def update
    @user = set_user
    if @user.update(user_params)
      render json: { message: 'success', data: [@user] }
    else
      render json: { message: 'failure', errors: [@user.errors] }
    end
  end

  def destroy
    @user = set_user
    render json: { message: 'success', data: [@user] }
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:user_code, :user_name, :password, :password_confirmation)
  end

end
